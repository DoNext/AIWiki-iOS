#!/bin/sh
set -euo pipefail

# cd to the root of the repository so agvtool can find the Xcode project
cd ..

echo "[ci_post_clone] Run repository checks"
bash scripts/check_all.sh

if [ -n "${CI_BUILD_NUMBER:-}" ]; then
  echo "[ci_post_clone] Set build number to ${CI_BUILD_NUMBER}"
  xcrun agvtool new-version -all "${CI_BUILD_NUMBER}" >/dev/null
else
  echo "[ci_post_clone] CI_BUILD_NUMBER not found, keeping current build number"
fi

if [ -n "${MARKETING_VERSION_OVERRIDE:-}" ]; then
  echo "[ci_post_clone] Set marketing version to ${MARKETING_VERSION_OVERRIDE}"
  xcrun agvtool new-marketing-version "${MARKETING_VERSION_OVERRIDE}" >/dev/null
fi

echo "[ci_post_clone] Done"
