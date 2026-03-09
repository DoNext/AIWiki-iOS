#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOCALE="${1:-en-US}"
DESTINATION="${2:-platform=iOS Simulator,name=iPhone 17 Pro Max}"

case "$LOCALE" in
  zh-Hans|en-US)
    ;;
  *)
    echo "Unsupported locale: $LOCALE"
    echo "Usage: bash scripts/generate_screenshots.sh [zh-Hans|en-US] [destination]"
    exit 1
    ;;
esac

RAW_DIR="$ROOT_DIR/screenshots/raw/$LOCALE"
APPSTORE_DIR="$ROOT_DIR/screenshots/AppStore/$LOCALE"
DERIVED_DATA_DIR="/tmp/aiwiki-screenshot-dd"

if [[ "$LOCALE" == "en-US" ]]; then
  TEST_LANGUAGE="en"
  TEST_REGION="US"
else
  TEST_LANGUAGE="zh-Hans"
  TEST_REGION="CN"
fi

mkdir -p "$RAW_DIR" "$APPSTORE_DIR"

echo "Generating raw screenshots for locale: $LOCALE"
echo "Destination: $DESTINATION"

xcodebuild \
  -project "$ROOT_DIR/AIWiki.xcodeproj" \
  -scheme AIWiki \
  -destination "$DESTINATION" \
  -testLanguage "$TEST_LANGUAGE" \
  -testRegion "$TEST_REGION" \
  -derivedDataPath "$DERIVED_DATA_DIR" \
  CODE_SIGNING_ALLOWED=NO \
  test \
  -only-testing:AIWikiUITests/ScreenshotTests/testCaptureScreenshots

echo "Generating App Store composites for locale: $LOCALE"
swift "$ROOT_DIR/screenshots/make_screenshots.swift" "$LOCALE"

echo "Done."
echo "Raw screenshots: $RAW_DIR"
echo "App Store screenshots: $APPSTORE_DIR"
