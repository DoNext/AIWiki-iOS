#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Usage: sh tools/init_metadata.sh /path/to/app-repo /path/to/metadata.env

Generate fastlane metadata files for en-US and zh-Hans from a simple env file.
EOF
}

if [ "$#" -ne 2 ]; then
  usage
  exit 1
fi

TARGET_DIR="$1"
ENV_FILE="$2"

if [ ! -d "${TARGET_DIR}" ]; then
  echo "Target directory does not exist: ${TARGET_DIR}" >&2
  exit 1
fi

if [ ! -f "${ENV_FILE}" ]; then
  echo "Metadata env file does not exist: ${ENV_FILE}" >&2
  exit 1
fi

# shellcheck disable=SC1090
. "${ENV_FILE}"

require_var() {
  name="$1"
  eval "value=\${${name}:-}"
  if [ -z "${value}" ]; then
    echo "Missing required variable: ${name}" >&2
    exit 1
  fi
}

write_file() {
  path="$1"
  content="$2"

  mkdir -p "$(dirname "${path}")"
  printf '%s\n' "${content}" > "${path}"
  echo "Wrote: ${path}"
}

for required in \
  APP_NAME_EN \
  APP_NAME_ZH \
  SUBTITLE_EN \
  SUBTITLE_ZH \
  DESCRIPTION_EN \
  DESCRIPTION_ZH \
  KEYWORDS_EN \
  KEYWORDS_ZH \
  PROMOTIONAL_TEXT_EN \
  PROMOTIONAL_TEXT_ZH \
  RELEASE_NOTES_EN \
  RELEASE_NOTES_ZH \
  SUPPORT_URL
do
  require_var "${required}"
done

METADATA_ROOT="${TARGET_DIR}/fastlane/metadata"

write_file "${METADATA_ROOT}/en-US/name.txt" "${APP_NAME_EN}"
write_file "${METADATA_ROOT}/en-US/subtitle.txt" "${SUBTITLE_EN}"
write_file "${METADATA_ROOT}/en-US/description.txt" "${DESCRIPTION_EN}"
write_file "${METADATA_ROOT}/en-US/keywords.txt" "${KEYWORDS_EN}"
write_file "${METADATA_ROOT}/en-US/promotional_text.txt" "${PROMOTIONAL_TEXT_EN}"
write_file "${METADATA_ROOT}/en-US/release_notes.txt" "${RELEASE_NOTES_EN}"
write_file "${METADATA_ROOT}/en-US/support_url.txt" "${SUPPORT_URL}"

write_file "${METADATA_ROOT}/zh-Hans/name.txt" "${APP_NAME_ZH}"
write_file "${METADATA_ROOT}/zh-Hans/subtitle.txt" "${SUBTITLE_ZH}"
write_file "${METADATA_ROOT}/zh-Hans/description.txt" "${DESCRIPTION_ZH}"
write_file "${METADATA_ROOT}/zh-Hans/keywords.txt" "${KEYWORDS_ZH}"
write_file "${METADATA_ROOT}/zh-Hans/promotional_text.txt" "${PROMOTIONAL_TEXT_ZH}"
write_file "${METADATA_ROOT}/zh-Hans/release_notes.txt" "${RELEASE_NOTES_ZH}"
write_file "${METADATA_ROOT}/zh-Hans/support_url.txt" "${SUPPORT_URL}"

echo
echo "Metadata initialization complete."
