#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT_DIR/data/processed/tools.seed.json"
DST="$ROOT_DIR/ios/AIWiki/Resources/Seed/tools.seed.json"

if [[ ! -f "$SRC" ]]; then
  echo "source file not found: $SRC"
  exit 1
fi

mkdir -p "$(dirname "$DST")"
cp "$SRC" "$DST"
echo "synced: $SRC -> $DST"
