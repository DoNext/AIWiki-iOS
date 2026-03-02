#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

python3 scripts/collect/collect_sources.py \
  --catalog data/sources/source_catalog.json \
  --out-dir data/raw/sources

python3 scripts/collect/normalize_sources.py \
  --raw-dir data/raw/sources \
  --decisions data/sources/review_decisions.json \
  --out data/processed/learning/learning_materials.json

python3 scripts/collect/merge_learning.py \
  --materials data/processed/learning/learning_materials.json \
  --out data/processed/learning/learning_materials.approved.json

mkdir -p ios/AIWiki/Resources/Seed
cp data/processed/learning/learning_materials.approved.json ios/AIWiki/Resources/Seed/learning_materials.json

echo "learning pipeline done."
echo "next: run review if needed -> python3 scripts/collect/review_learning.py --materials data/processed/learning/learning_materials.json list"
