#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f "$ROOT_DIR/Gemfile" ]]; then
  export BUNDLE_PATH="$ROOT_DIR/vendor/bundle"
  export BUNDLE_BIN="$ROOT_DIR/vendor/bundle/bin"
  export BUNDLE_APP_CONFIG="$ROOT_DIR/.bundle"
  export PATH="$BUNDLE_BIN:$PATH"
fi

usage() {
  cat <<'EOF'
Usage: bash scripts/release_to_app_store.sh [options]

Options:
  --version <value>            App Store version string, e.g. 1.0.0
  --build-number <value>       Specific build number to attach for review
  --with-screenshots           Regenerate localized screenshots before upload
  --skip-metadata              Upload screenshots/build only
  --skip-screenshots           Upload metadata/build only
  --upload-binary              Upload the binary together with metadata/screenshots
  --ipa-path <path>            IPA path to upload when using --upload-binary
  --no-submit                  Do not submit for review after upload
  --auto-release               Release automatically after approval
  --locales <csv>              Override locales, e.g. en-US,zh-Hans
  --destination <value>        Simulator destination for screenshot generation
  --help                       Show this message
EOF
}

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "Missing required environment variable: $name" >&2
    exit 1
  fi
}

if ! command -v fastlane >/dev/null 2>&1 && ! command -v bundle >/dev/null 2>&1; then
  echo "fastlane is not installed. Run 'bundle install' or install fastlane first." >&2
  exit 1
fi

VERSION=""
BUILD_NUMBER=""
LOCALES=""
DESTINATION=""
IPA_PATH=""
WITH_SCREENSHOTS=0
SKIP_METADATA=0
SKIP_SCREENSHOTS=0
SKIP_BINARY_UPLOAD=1
SUBMIT_FOR_REVIEW=1
AUTO_RELEASE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      VERSION="$2"
      shift 2
      ;;
    --build-number)
      BUILD_NUMBER="$2"
      shift 2
      ;;
    --with-screenshots)
      WITH_SCREENSHOTS=1
      shift
      ;;
    --skip-metadata)
      SKIP_METADATA=1
      shift
      ;;
    --skip-screenshots)
      SKIP_SCREENSHOTS=1
      shift
      ;;
    --upload-binary)
      SKIP_BINARY_UPLOAD=0
      shift
      ;;
    --ipa-path)
      IPA_PATH="$2"
      shift 2
      ;;
    --no-submit)
      SUBMIT_FOR_REVIEW=0
      shift
      ;;
    --auto-release)
      AUTO_RELEASE=1
      shift
      ;;
    --locales)
      LOCALES="$2"
      shift 2
      ;;
    --destination)
      DESTINATION="$2"
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

require_env APP_STORE_CONNECT_KEY_ID
require_env APP_STORE_CONNECT_ISSUER_ID
if [[ -z "${APP_STORE_CONNECT_KEY_FILE:-}" && -z "${APP_STORE_CONNECT_KEY_CONTENT:-}" ]]; then
  echo "Missing required environment variable: APP_STORE_CONNECT_KEY_FILE or APP_STORE_CONNECT_KEY_CONTENT" >&2
  exit 1
fi

FASTLANE=(fastlane ios appstore_release)
if command -v bundle >/dev/null 2>&1 && [[ -f "$ROOT_DIR/Gemfile" ]]; then
  FASTLANE=(bundle exec fastlane ios appstore_release)
fi

if [[ "$WITH_SCREENSHOTS" -eq 1 ]]; then
  SCREENSHOT_CMD=(fastlane ios refresh_screenshots)
  if command -v bundle >/dev/null 2>&1 && [[ -f "$ROOT_DIR/Gemfile" ]]; then
    SCREENSHOT_CMD=(bundle exec fastlane ios refresh_screenshots)
  fi

  if [[ -n "$LOCALES" ]]; then
    "${SCREENSHOT_CMD[@]}" locales:"$LOCALES" ${DESTINATION:+destination:"$DESTINATION"}
  else
    "${SCREENSHOT_CMD[@]}" ${DESTINATION:+destination:"$DESTINATION"}
  fi
fi

FASTLANE_ARGS=(
  "${FASTLANE[@]}"
  skip_metadata:"$SKIP_METADATA"
  skip_screenshots:"$SKIP_SCREENSHOTS"
  skip_binary_upload:"$SKIP_BINARY_UPLOAD"
  submit_for_review:"$SUBMIT_FOR_REVIEW"
  auto_release:"$AUTO_RELEASE"
)

if [[ -n "$VERSION" ]]; then
  FASTLANE_ARGS+=(version:"$VERSION")
fi

if [[ -n "$BUILD_NUMBER" ]]; then
  FASTLANE_ARGS+=(build_number:"$BUILD_NUMBER")
fi

if [[ -n "$LOCALES" ]]; then
  FASTLANE_ARGS+=(locales:"$LOCALES")
fi

if [[ -n "$IPA_PATH" ]]; then
  FASTLANE_ARGS+=(ipa:"$IPA_PATH")
fi

"${FASTLANE_ARGS[@]}"
