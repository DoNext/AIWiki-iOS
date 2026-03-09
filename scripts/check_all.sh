#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[check_all] Run English localization style check"
python3 scripts/check_en_localizable_style.py

echo "[check_all] Done"
