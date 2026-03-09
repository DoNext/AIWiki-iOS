#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Usage: sh release-template/tools/install_into_app.sh /path/to/app-repo [--force]

Copies the reusable release template files into the target app repository.

Options:
  --force    Overwrite existing template-managed files in the target repo
EOF
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  usage
  exit 1
fi

TARGET_DIR="$1"
FORCE_OVERWRITE=0

if [ "${2:-}" = "--force" ]; then
  FORCE_OVERWRITE=1
elif [ "$#" -eq 2 ]; then
  usage
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [ ! -d "${TARGET_DIR}" ]; then
  echo "Target directory does not exist: ${TARGET_DIR}" >&2
  exit 1
fi

copy_file() {
  src="$1"
  dest="$2"

  mkdir -p "$(dirname "${dest}")"

  if [ -e "${dest}" ] && [ "${FORCE_OVERWRITE}" -ne 1 ]; then
    echo "Skip existing file: ${dest}"
    return 0
  fi

  cp "${src}" "${dest}"
  echo "Copied: ${dest}"
}

copy_tree() {
  src_dir="$1"
  dest_dir="$2"

  find "${src_dir}" -type f | while IFS= read -r src; do
    rel="${src#${src_dir}/}"
    copy_file "${src}" "${dest_dir}/${rel}"
  done
}

copy_file "${TEMPLATE_ROOT}/Gemfile" "${TARGET_DIR}/Gemfile"
copy_tree "${TEMPLATE_ROOT}/ci_scripts" "${TARGET_DIR}/ci_scripts"
copy_tree "${TEMPLATE_ROOT}/scripts" "${TARGET_DIR}/scripts"
copy_tree "${TEMPLATE_ROOT}/fastlane" "${TARGET_DIR}/fastlane"

mkdir -p "${TARGET_DIR}/screenshots/AppStore/en-US"
mkdir -p "${TARGET_DIR}/screenshots/AppStore/zh-Hans"

echo
echo "Install complete."
echo "Next steps:"
echo "1. Replace template placeholders in fastlane metadata files."
echo "2. Set APP_BUNDLE_ID and APP_PRODUCT_NAME for the new app."
echo "3. Add real screenshots under screenshots/AppStore/<locale>."
echo "4. Configure the Xcode Cloud Release workflow environment variables."
