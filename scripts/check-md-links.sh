#!/usr/bin/env bash
# Fail if a relative Markdown (or llms.txt) link does not exist on disk.
# Scans README, docs, CONTRIBUTING, AGENTS, and llms.txt. External URLs,
# same-file #anchors, and bare placeholders like (url) are skipped.
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
  esac
  # Template placeholders: [Name](url)
  if [[ "$1" =~ ^[A-Za-z0-9_-]+$ ]]; then
    return 0
  fi
  return 1
}

extract_targets() {
  grep -oE '\[[^][]+\]\([^()]+\)' "$1" | sed -E 's/^\[[^][]+\]\((.+)\)$/\1/' || true
}

files=(README.md CONTRIBUTING.md AGENTS.md llms.txt)
shopt -s nullglob
files+=(docs/*.md)

for rel in "${files[@]}"; do
  if [[ ! -f "${rel}" ]]; then
    fail "missing scan target: ${rel}"
    continue
  fi
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
  done < <(extract_targets "${rel}")
done

if (( failures > 0 )); then
  printf '\n%d broken relative link(s)\n' "${failures}" >&2
  exit 1
fi

printf 'Relative markdown links: ok\n'
