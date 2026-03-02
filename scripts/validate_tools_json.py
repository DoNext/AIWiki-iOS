#!/usr/bin/env python3
import json
import re
import sys
from datetime import datetime
from pathlib import Path

ALLOWED_CATEGORIES = {
    "聊天机器人",
    "编程助手",
    "图像生成",
    "数据分析",
    "多模态模型",
}

ID_RE = re.compile(r"^[a-z0-9-]+$")
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def is_valid_date(value: str) -> bool:
    if not DATE_RE.match(value):
        return False
    try:
        datetime.strptime(value, "%Y-%m-%d")
        return True
    except ValueError:
        return False


def validate_record(record: dict, idx: int, seen_ids: set, seen_urls: set) -> list[str]:
    errs: list[str] = []
    prefix = f"[#{idx}]"

    required = [
        "id",
        "name",
        "intro",
        "features",
        "company",
        "url",
        "icon",
        "category",
        "source_url",
        "last_verified_at",
    ]
    for key in required:
        if key not in record or record[key] in ("", None):
            errs.append(f"{prefix} missing `{key}`")

    if errs:
        return errs

    rid = str(record["id"])
    if not ID_RE.match(rid):
        errs.append(f"{prefix} invalid `id`: {rid}")
    if rid in seen_ids:
        errs.append(f"{prefix} duplicate `id`: {rid}")
    seen_ids.add(rid)

    name = str(record["name"])
    if len(name) > 60:
        errs.append(f"{prefix} `name` too long (>60)")

    intro = str(record["intro"])
    if not (10 <= len(intro) <= 140):
        errs.append(f"{prefix} `intro` length must be 10-140")

    features = record["features"]
    if not isinstance(features, list) or not (1 <= len(features) <= 8):
        errs.append(f"{prefix} `features` must be array with 1-8 items")
    else:
        for item in features:
            if not isinstance(item, str) or not (2 <= len(item) <= 30):
                errs.append(f"{prefix} invalid feature item: {item}")
                break

    for key in ("url", "source_url"):
        value = str(record[key])
        if not value.startswith("https://"):
            errs.append(f"{prefix} `{key}` must start with https://")

    url = str(record["url"])
    if url in seen_urls:
        errs.append(f"{prefix} duplicate `url`: {url}")
    seen_urls.add(url)

    category = str(record["category"])
    if category not in ALLOWED_CATEGORIES:
        errs.append(f"{prefix} invalid `category`: {category}")

    date_text = str(record["last_verified_at"])
    if not is_valid_date(date_text):
        errs.append(f"{prefix} invalid `last_verified_at`: {date_text}")

    optional_string_list_fields = [
        "use_cases",
        "best_practices",
        "strengths",
        "limitations",
    ]
    for field in optional_string_list_fields:
        if field in record and record[field] is not None:
            value = record[field]
            if not isinstance(value, list) or len(value) == 0:
                errs.append(f"{prefix} `{field}` must be non-empty array when provided")
                continue
            for item in value:
                if not isinstance(item, str) or len(item.strip()) < 2:
                    errs.append(f"{prefix} invalid item in `{field}`: {item}")
                    break

    if "prompt_templates" in record and record["prompt_templates"] is not None:
        templates = record["prompt_templates"]
        if not isinstance(templates, list) or len(templates) == 0:
            errs.append(f"{prefix} `prompt_templates` must be non-empty array when provided")
        else:
            for item in templates:
                if not isinstance(item, dict):
                    errs.append(f"{prefix} invalid template object in `prompt_templates`")
                    break
                title = item.get("title")
                prompt = item.get("prompt")
                if not isinstance(title, str) or len(title.strip()) < 2:
                    errs.append(f"{prefix} invalid `prompt_templates[].title`")
                    break
                if not isinstance(prompt, str) or len(prompt.strip()) < 10:
                    errs.append(f"{prefix} invalid `prompt_templates[].prompt`")
                    break

    if "access" in record and record["access"] is not None:
        access = record["access"]
        if not isinstance(access, dict):
            errs.append(f"{prefix} `access` must be object when provided")
        else:
            if not isinstance(access.get("pricing"), str) or len(access["pricing"].strip()) < 2:
                errs.append(f"{prefix} invalid `access.pricing`")
            if not isinstance(access.get("account_required"), bool):
                errs.append(f"{prefix} invalid `access.account_required`")
            if not isinstance(access.get("api_available"), bool):
                errs.append(f"{prefix} invalid `access.api_available`")
            platforms = access.get("platforms")
            if not isinstance(platforms, list) or len(platforms) == 0:
                errs.append(f"{prefix} `access.platforms` must be non-empty array")
            else:
                for p in platforms:
                    if not isinstance(p, str) or len(p.strip()) < 2:
                        errs.append(f"{prefix} invalid item in `access.platforms`: {p}")
                        break

    return errs


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: validate_tools_json.py <json-path>")
        return 2

    path = Path(sys.argv[1])
    if not path.exists():
        print(f"file not found: {path}")
        return 2

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        print(f"invalid json: {exc}")
        return 1

    if not isinstance(data, list):
        print("top-level json must be an array")
        return 1

    errors: list[str] = []
    seen_ids: set[str] = set()
    seen_urls: set[str] = set()

    for i, record in enumerate(data, start=1):
        if not isinstance(record, dict):
            errors.append(f"[#{i}] record must be object")
            continue
        errors.extend(validate_record(record, i, seen_ids, seen_urls))

    if errors:
        print("validation failed:")
        for err in errors:
            print(f"- {err}")
        return 1

    print(f"validation passed: {len(data)} records")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
