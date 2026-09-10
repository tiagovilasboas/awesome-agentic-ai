#!/usr/bin/env bash
# Fail if a relative Markdown (or llms.txt) link does not exist on disk.
# External URLs and same-file #anchors are skipped. No network fetch.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

failures=0

fail() {
  printf 'FAIL | %s\n' "$1" >&2
  failures=$((failures + 1))
}

is_skipped() {
  case "$1" in
    http://*|https://*|mailto:*|\#*) return 0 ;;
    *) return 1 ;;
  esac
}

# Print the URL/path inside each [label](target) on the file (single line).
extract_targets() {
  grep -oE '\[[^][]+\]\([^()]+\)' "$1" | sed -E 's/^\[[^][]+\]\((.+)\)$/\1/' || true
}

while IFS= read -r file; do
  rel="${file#./}"
  dir="$(dirname "${rel}")"

  while IFS= read -r raw || [[ -n "${raw}" ]]; do
    [[ -z "${raw}" ]] && continue
    target="${raw%%[[:space:]]*}"
    target="${target#<}"
    target="${target%>}"
    target="${target%%\"*}"
    target="${target%%\'*}"
    [[ -z "${target}" ]] && continue
    if is_skipped "${target}"; then
      continue
    fi
    path_part="${target%%#*}"
    [[ -z "${path_part}" ]] && continue

    resolved="$(realpath -m "${dir}/${path_part}")"
    if [[ ! -e "${resolved}" ]]; then
      fail "${rel} -> ${target}"
    fi
  done < <(extract_targets "${file}")
done < <(find . -type f \( -name '*.md' -o -name 'llms.txt' \) ! -path './.git/*' | sort)

if (( failures > 0 )); then
  printf '\n%d broken relative link(s)\n' "${failures}" >&2
  exit 1
fi

printf 'Relative markdown links: ok\n'
