#!/usr/bin/env python3
import argparse
import json
from pathlib import Path


def run(materials_path: Path, out_path: Path) -> None:
    materials = json.loads(materials_path.read_text(encoding="utf-8"))
    approved = [item for item in materials if item.get("review_status") == "APPROVED"]
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(approved, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"approved {len(approved)}/{len(materials)} -> {out_path}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Merge approved learning materials.")
    parser.add_argument(
        "--materials",
        default="data/processed/learning/learning_materials.json",
        help="Normalized learning materials JSON.",
    )
    parser.add_argument(
        "--out",
        default="data/processed/learning/learning_materials.approved.json",
        help="Approved output JSON.",
    )
    args = parser.parse_args()
    run(Path(args.materials), Path(args.out))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
