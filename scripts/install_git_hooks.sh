#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS_DIR="$ROOT_DIR/.githooks"

if [[ ! -d "$HOOKS_DIR" ]]; then
  echo "hooks directory not found: $HOOKS_DIR"
  exit 1
fi

git -C "$ROOT_DIR" config core.hooksPath .githooks
chmod +x "$HOOKS_DIR"/pre-commit

echo "installed git hooks from: $HOOKS_DIR"
echo "git config core.hooksPath=$(git -C "$ROOT_DIR" config core.hooksPath)"
