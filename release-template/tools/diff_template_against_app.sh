#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Usage: sh release-template/tools/diff_template_against_app.sh /path/to/app-repo

Shows differences between the portable release template and the target app repo
for the shared release automation files.
EOF
}

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

TARGET_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [ ! -d "${TARGET_DIR}" ]; then
  echo "Target directory does not exist: ${TARGET_DIR}" >&2
  exit 1
fi

compare_file() {
  template_file="$1"
  target_file="$2"

  if [ ! -f "${target_file}" ]; then
    echo "Missing in target: ${target_file}"
    return 0
  fi

  if cmp -s "${template_file}" "${target_file}"; then
    echo "Match: ${target_file}"
  else
    echo "Diff: ${target_file}"
    diff -u "${template_file}" "${target_file}" || true
  fi
}

compare_tree() {
  src_dir="$1"
  dest_dir="$2"

  find "${src_dir}" -type f | while IFS= read -r src; do
    rel="${src#${src_dir}/}"
    compare_file "${src}" "${dest_dir}/${rel}"
  done
}

compare_file "${TEMPLATE_ROOT}/Gemfile" "${TARGET_DIR}/Gemfile"
compare_tree "${TEMPLATE_ROOT}/ci_scripts" "${TARGET_DIR}/ci_scripts"
compare_tree "${TEMPLATE_ROOT}/scripts" "${TARGET_DIR}/scripts"
compare_tree "${TEMPLATE_ROOT}/fastlane" "${TARGET_DIR}/fastlane"
