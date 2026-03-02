#!/usr/bin/env python3
import argparse
import json
from datetime import datetime
from pathlib import Path


def first_non_empty(values):
    for value in values:
        if value and str(value).strip():
            return str(value).strip()
    return ""


def pick_capabilities(page: dict) -> list[str]:
    candidates = []
    for text in page.get("h2", []):
        t = text.strip()
        if 4 <= len(t) <= 80:
            candidates.append(t)
    return candidates[:6]


def pick_getting_started(page: dict) -> list[str]:
    items = []
    for paragraph in page.get("paragraphs", []):
        p = paragraph.strip()
        if 20 <= len(p) <= 140:
            items.append(p)
        if len(items) >= 4:
            break
    return items


def summarize_page(page: dict) -> str:
    return first_non_empty(
        [
            page.get("meta_description", ""),
            page.get("title", ""),
            *(page.get("paragraphs", [])[:2]),
        ]
    )


def normalize_one(raw_file: Path, review_map: dict[str, dict]) -> dict:
    payload = json.loads(raw_file.read_text(encoding="utf-8"))
    pages = [p for p in payload.get("pages", []) if p.get("ok")]
    primary = pages[0] if pages else {}
    summary = summarize_page(primary) or f"{payload['name']} 官方资料摘要待补充。"
    core_capabilities = pick_capabilities(primary)
    getting_started = pick_getting_started(primary)
    official_links = [p["url"] for p in pages] or payload.get("learning_urls", [])
    caveats = []
    if not pages:
        caveats.append("官网内容抓取失败，需人工补录。")
    if not core_capabilities:
        caveats.append("未自动提取到能力点，建议人工编辑。")
    if not getting_started:
        caveats.append("未自动提取到入门步骤，建议人工编辑。")

    decision = review_map.get(payload["id"], {})
    review_status = decision.get("status", "PENDING")
    review_note = decision.get("note", "")

    return {
        "id": payload["id"],
        "name": payload["name"],
        "summary": summary,
        "core_capabilities": core_capabilities,
        "getting_started": getting_started,
        "official_links": official_links,
        "caveats": caveats,
        "last_verified_at": datetime.now().strftime("%Y-%m-%d"),
        "review_status": review_status,
        "review_note": review_note,
        "raw_file": str(raw_file),
        "fetched_at": payload.get("fetched_at", ""),
    }


def run(raw_dir: Path, decisions_file: Path, out_file: Path) -> None:
    raw_files = sorted(raw_dir.glob("*.json"))
    decisions_payload = json.loads(decisions_file.read_text(encoding="utf-8"))
    review_map = decisions_payload.get("decisions", {})
    materials = [normalize_one(path, review_map) for path in raw_files]
    out_file.parent.mkdir(parents=True, exist_ok=True)
    out_file.write_text(json.dumps(materials, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"normalized {len(materials)} records -> {out_file}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Normalize raw source pages into learning materials.")
    parser.add_argument("--raw-dir", default="data/raw/sources", help="Raw source directory.")
    parser.add_argument(
        "--decisions",
        default="data/sources/review_decisions.json",
        help="Review decisions JSON.",
    )
    parser.add_argument(
        "--out",
        default="data/processed/learning/learning_materials.json",
        help="Normalized learning materials JSON.",
    )
    args = parser.parse_args()
    run(Path(args.raw_dir), Path(args.decisions), Path(args.out))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
