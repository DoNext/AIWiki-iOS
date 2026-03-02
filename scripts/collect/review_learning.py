#!/usr/bin/env python3
import argparse
import json
from datetime import datetime
from pathlib import Path


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def save_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def list_status(materials_path: Path) -> None:
    materials = json.loads(materials_path.read_text(encoding="utf-8"))
    for item in materials:
        print(f"{item['id']:<20} {item.get('review_status', 'PENDING'):<10} {item['name']}")


def update_decisions(
    decisions_path: Path, ids: list[str], status: str, note: str
) -> None:
    payload = load_json(decisions_path)
    decisions = payload.setdefault("decisions", {})
    now = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    for tool_id in ids:
        decisions[tool_id] = {"status": status, "note": note, "reviewed_at": now}
    save_json(decisions_path, payload)
    print(f"updated {len(ids)} ids -> {status}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Review helper for learning materials.")
    parser.add_argument(
        "--materials",
        default="data/processed/learning/learning_materials.json",
        help="Normalized learning materials JSON.",
    )
    parser.add_argument(
        "--decisions",
        default="data/sources/review_decisions.json",
        help="Review decisions JSON.",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("list", help="List current review status.")

    approve = sub.add_parser("approve", help="Approve ids.")
    approve.add_argument("ids", nargs="+", help="Tool ids to approve.")
    approve.add_argument("--note", default="", help="Review note.")

    reject = sub.add_parser("reject", help="Reject ids.")
    reject.add_argument("ids", nargs="+", help="Tool ids to reject.")
    reject.add_argument("--note", default="", help="Review note.")

    args = parser.parse_args()
    materials_path = Path(args.materials)
    decisions_path = Path(args.decisions)

    if args.command == "list":
        list_status(materials_path)
    elif args.command == "approve":
        update_decisions(decisions_path, args.ids, "APPROVED", args.note)
    elif args.command == "reject":
        update_decisions(decisions_path, args.ids, "REJECTED", args.note)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
