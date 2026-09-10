#!/usr/bin/env bash
# Keep fail-closed judgment visible: Rejected must exist and list enough classes.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
README="${ROOT}/README.md"
MIN="${MIN_REJECTED_ROWS:-10}"
HEADING='## Rejected / out of scope'
TOC='- [Rejected / out of scope](#rejected--out-of-scope)'

if [[ ! -f "${README}" ]]; then
  printf 'FAIL | README.md missing\n' >&2
  exit 1
fi

if ! grep -qxF "${HEADING}" "${README}"; then
  printf 'FAIL | README.md missing heading: %s\n' "${HEADING}" >&2
  exit 1
fi

if ! grep -qxF "${TOC}" "${README}"; then
  printf 'FAIL | README.md Contents missing: %s\n' "${TOC}" >&2
  exit 1
fi

section="$(awk '
  /^## Rejected \/ out of scope$/ { p = 1; next }
  /^## / && p { exit }
  p { print }
' "${README}")"

rows="$(printf '%s\n' "${section}" | awk '
  /^\|/ && $0 !~ /^\|[[:space:]]*-+/ && $0 !~ /^\|[[:space:]]*We refuse/ { c++ }
  END { print c + 0 }
')"

if (( rows < MIN )); then
  printf 'FAIL | Rejected table has %s row(s); need at least %s\n' "${rows}" "${MIN}" >&2
  exit 1
fi

printf 'OK   | Rejected / out of scope: %s refuse-classes (min %s)\n' "${rows}" "${MIN}"
