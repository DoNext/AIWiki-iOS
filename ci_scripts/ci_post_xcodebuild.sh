#!/bin/sh
set -euo pipefail

cd ..

truthy() {
  case "$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')" in
    1|true|yes|y)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

if ! truthy "${XCODE_CLOUD_AUTO_SUBMIT:-0}"; then
  echo "[ci_post_xcodebuild] XCODE_CLOUD_AUTO_SUBMIT disabled, skipping App Store submission"
  exit 0
fi

if [ -n "${XCODE_CLOUD_RELEASE_WORKFLOW:-}" ] && [ "${CI_WORKFLOW:-}" != "${XCODE_CLOUD_RELEASE_WORKFLOW}" ]; then
  echo "[ci_post_xcodebuild] Workflow ${CI_WORKFLOW:-unknown} does not match XCODE_CLOUD_RELEASE_WORKFLOW=${XCODE_CLOUD_RELEASE_WORKFLOW}, skipping"
  exit 0
fi

if [ -z "${CI_ARCHIVE_PATH:-}" ] || [ ! -d "${CI_ARCHIVE_PATH}" ]; then
  echo "[ci_post_xcodebuild] CI_ARCHIVE_PATH is missing, expected an archive workflow" >&2
  exit 1
fi

INFO_PLIST="${CI_ARCHIVE_PATH}/Products/Applications/AIWiki.app/Info.plist"
if [ ! -f "${INFO_PLIST}" ]; then
  echo "[ci_post_xcodebuild] App Info.plist not found at ${INFO_PLIST}" >&2
  exit 1
fi

VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "${INFO_PLIST}")"
BUILD_NUMBER="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "${INFO_PLIST}")"

if [ -n "${CI_APP_STORE_SIGNED_APP_PATH:-}" ]; then
  case "${CI_APP_STORE_SIGNED_APP_PATH}" in
    *.ipa)
      IPA_PATH="${CI_APP_STORE_SIGNED_APP_PATH}"
      ;;
    *)
      IPA_PATH="$(find "${CI_APP_STORE_SIGNED_APP_PATH}" -name '*.ipa' | head -n 1)"
      ;;
  esac
elif [ -n "${CI_APP_STORE_SIGNED_ARCHIVE_PATH:-}" ]; then
  IPA_PATH="$(find "${CI_APP_STORE_SIGNED_ARCHIVE_PATH}" -name '*.ipa' | head -n 1)"
else
  echo "[ci_post_xcodebuild] Missing CI_APP_STORE_SIGNED_APP_PATH and CI_APP_STORE_SIGNED_ARCHIVE_PATH" >&2
  exit 1
fi

if [ -z "${IPA_PATH:-}" ] || [ ! -e "${IPA_PATH}" ]; then
  echo "[ci_post_xcodebuild] App Store signed artifact not found" >&2
  exit 1
fi

echo "[ci_post_xcodebuild] Submit version ${VERSION} build ${BUILD_NUMBER} using ${IPA_PATH}"
bash scripts/release_to_app_store.sh \
  --upload-binary \
  --version "${VERSION}" \
  --build-number "${BUILD_NUMBER}" \
  --ipa-path "${IPA_PATH}"

echo "[ci_post_xcodebuild] Done"
