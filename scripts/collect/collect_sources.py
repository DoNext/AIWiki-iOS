#!/usr/bin/env python3
import argparse
import json
import re
import ssl
import time
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path
from urllib.error import URLError, HTTPError
from urllib.request import HTTPSHandler, HTTPRedirectHandler, Request, build_opener as urllib_build_opener


class SimpleHTMLExtractor(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.in_title = False
        self.capture_tag = None
        self.current_text = []
        self.title = ""
        self.meta_description = ""
        self.h1 = []
        self.h2 = []
        self.paragraphs = []

    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        if tag == "title":
            self.in_title = True
        if tag in {"h1", "h2", "p"}:
            self.capture_tag = tag
            self.current_text = []
        if tag == "meta" and attrs_dict.get("name", "").lower() == "description":
            self.meta_description = attrs_dict.get("content", "").strip()

    def handle_endtag(self, tag):
        if tag == "title":
            self.in_title = False
        if self.capture_tag == tag:
            text = normalize_text(" ".join(self.current_text))
            if text:
                if tag == "h1":
                    self.h1.append(text)
                elif tag == "h2":
                    self.h2.append(text)
                elif tag == "p":
                    self.paragraphs.append(text)
            self.capture_tag = None
            self.current_text = []

    def handle_data(self, data):
        if self.in_title:
            self.title += data
        if self.capture_tag is not None:
            self.current_text.append(data)


def normalize_text(text: str) -> str:
    text = re.sub(r"\s+", " ", text).strip()
    return text


DEFAULT_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/126.0.0.0 Safari/537.36"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.9,zh-CN;q=0.8",
    "Cache-Control": "no-cache",
}


class HTTP308RedirectHandler(HTTPRedirectHandler):
    def http_error_308(self, req, fp, code, msg, headers):
        return self.http_error_302(req, fp, code, msg, headers)


def build_http_opener():
    context = ssl.create_default_context()
    if hasattr(ssl, "TLSVersion"):
        context.minimum_version = ssl.TLSVersion.TLSv1_2
    return urllib_build_opener(HTTP308RedirectHandler(), HTTPSHandler(context=context))


def _decode_body(body: bytes, content_type: str) -> str:
    charset_match = re.search(r"charset=([a-zA-Z0-9_\-]+)", content_type or "", re.IGNORECASE)
    candidates = []
    if charset_match:
        candidates.append(charset_match.group(1))
    candidates.extend(["utf-8", "utf-16", "latin-1"])
    for encoding in candidates:
        try:
            return body.decode(encoding, errors="replace")
        except LookupError:
            continue
    return body.decode("utf-8", errors="replace")


def fetch_via_reader_fallback(url: str, timeout_sec: int, opener) -> dict:
    bare = re.sub(r"^https?://", "", url.strip())
    reader_url = f"https://r.jina.ai/http://{bare}"
    req = Request(
        url=reader_url,
        headers={
            "User-Agent": DEFAULT_HEADERS["User-Agent"],
            "Accept": "text/plain",
            "X-Timeout": str(timeout_sec),
        },
    )
    with opener.open(req, timeout=max(timeout_sec, 20)) as resp:
        text = _decode_body(resp.read(), resp.headers.get("Content-Type", "text/plain"))
    return {
        "body": text,
        "final_url": resp.geturl(),
        "fetched_via": "reader_fallback",
        "content_type": "text/plain",
    }


def fetch_content(url: str, timeout_sec: int, retries: int, use_reader_fallback: bool) -> dict:
    opener = build_http_opener()
    last_error = None
    for attempt in range(1, max(retries, 1) + 1):
        req = Request(url=url, headers=DEFAULT_HEADERS)
        try:
            with opener.open(req, timeout=timeout_sec) as resp:
                body = resp.read()
                content_type = resp.headers.get("Content-Type", "")
                text = _decode_body(body, content_type)
                return {
                    "body": text,
                    "final_url": resp.geturl(),
                    "fetched_via": "direct",
                    "content_type": content_type,
                }
        except HTTPError as exc:
            last_error = exc
            # Anti-bot 403 is common; fallback mirror often provides readable text.
            if use_reader_fallback and exc.code in {301, 302, 303, 307, 308, 401, 403, 406, 429}:
                try:
                    return fetch_via_reader_fallback(url, timeout_sec, opener)
                except Exception as fallback_exc:
                    last_error = fallback_exc
            if exc.code in {408, 425, 429, 500, 502, 503, 504} and attempt < retries:
                time.sleep(min(0.6 * attempt, 2.0))
                continue
            break
        except (URLError, TimeoutError, ssl.SSLError, ValueError) as exc:
            last_error = exc
            if attempt < retries:
                time.sleep(min(0.6 * attempt, 2.0))
                continue
            if use_reader_fallback:
                try:
                    return fetch_via_reader_fallback(url, timeout_sec, opener)
                except Exception as fallback_exc:
                    last_error = fallback_exc
            break
    raise RuntimeError(str(last_error))


def parse_markdown_fallback(markdown_text: str) -> dict:
    title = ""
    h1 = []
    h2 = []
    paragraphs = []
    meta_description = ""

    for raw_line in markdown_text.splitlines():
        line = raw_line
        line = re.sub(r"!\[([^\]]*)\]\([^)]+\)", r"\1", line)
        line = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", line)
        line = normalize_text(line)
        if not line:
            continue
        if line.startswith("Title:"):
            title = line.replace("Title:", "", 1).strip()
            continue
        if line.startswith("URL Source:") or line.startswith("Warning:"):
            continue
        if line.startswith("Markdown Content:"):
            line = normalize_text(line.replace("Markdown Content:", "", 1))
            if not line:
                continue
        if line.startswith("# "):
            heading = line[2:].strip()
            if heading:
                h1.append(heading)
            continue
        if line.startswith("## "):
            heading = line[3:].strip()
            if heading:
                h2.append(heading)
            continue
        if re.match(r"^[=\-]{3,}$", line):
            continue
        if len(line) >= 20:
            paragraphs.append(line)

    if not meta_description and paragraphs:
        meta_description = paragraphs[0][:180]
    return {
        "title": title,
        "meta_description": meta_description,
        "h1": h1[:5],
        "h2": h2[:20],
        "paragraphs": paragraphs[:80],
    }


def parse_one_url(url: str, timeout_sec: int, retries: int, use_reader_fallback: bool) -> dict:
    try:
        fetched = fetch_content(url, timeout_sec, retries, use_reader_fallback)
        content = fetched["body"]
        content_type = fetched.get("content_type", "")
        if "text/html" in content_type.lower():
            parser = SimpleHTMLExtractor()
            parser.feed(content)
            parsed = {
                "title": normalize_text(parser.title),
                "meta_description": parser.meta_description,
                "h1": parser.h1[:5],
                "h2": parser.h2[:20],
                "paragraphs": parser.paragraphs[:80],
            }
        else:
            parsed = parse_markdown_fallback(content)
        return {
            "url": url,
            "ok": True,
            "final_url": fetched.get("final_url", url),
            "fetched_via": fetched.get("fetched_via", "direct"),
            "title": parsed["title"],
            "meta_description": parsed["meta_description"],
            "h1": parsed["h1"],
            "h2": parsed["h2"],
            "paragraphs": parsed["paragraphs"],
            "error": None,
        }
    except Exception as exc:
        return {
            "url": url,
            "ok": False,
            "final_url": "",
            "fetched_via": "",
            "title": "",
            "meta_description": "",
            "h1": [],
            "h2": [],
            "paragraphs": [],
            "error": str(exc)[:500],
        }


def run(
    catalog_path: Path,
    out_dir: Path,
    timeout_sec: int,
    retries: int,
    use_reader_fallback: bool,
) -> None:
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    tools = catalog.get("tools", [])
    out_dir.mkdir(parents=True, exist_ok=True)
    fetched_at = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    for tool in tools:
        tool_id = tool["id"]
        name = tool["name"]
        urls = tool.get("learning_urls", [])
        results = [
            parse_one_url(url, timeout_sec, retries=retries, use_reader_fallback=use_reader_fallback)
            for url in urls
        ]
        payload = {
            "id": tool_id,
            "name": name,
            "primary_url": tool.get("primary_url", ""),
            "learning_urls": urls,
            "fetched_at": fetched_at,
            "pages": results,
        }
        out_file = out_dir / f"{tool_id}.json"
        out_file.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
        ok_count = sum(1 for x in results if x["ok"])
        print(f"{tool_id}: fetched {ok_count}/{len(results)} pages -> {out_file}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Collect official source pages for tools.")
    parser.add_argument(
        "--catalog",
        default="data/sources/source_catalog.json",
        help="Path to source catalog JSON.",
    )
    parser.add_argument(
        "--out-dir",
        default="data/raw/sources",
        help="Output directory for per-tool raw source JSON.",
    )
    parser.add_argument("--timeout", type=int, default=15, help="HTTP timeout seconds.")
    parser.add_argument("--retries", type=int, default=3, help="Retry attempts per URL.")
    parser.add_argument(
        "--disable-reader-fallback",
        action="store_true",
        help="Disable reader text mirror fallback for blocked pages.",
    )
    args = parser.parse_args()

    run(
        Path(args.catalog),
        Path(args.out_dir),
        args.timeout,
        args.retries,
        use_reader_fallback=not args.disable_reader_fallback,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
