#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  verify_media.sh VIDEO [EXPECTED_DURATION_SECONDS]

Checks the downloaded video with ffprobe:
  - file has a decodable video stream
  - duration matches the expected value within 2% (when provided)
  - height >= 720 (warns when the file looks like a low-res preview)
Exits non-zero on duration mismatch or missing video stream.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage
  [[ $# -lt 1 ]] && exit 2 || exit 0
fi

video=$1
expected=${2:-}

if [[ ! -f "$video" ]]; then
  echo "[error] file not found: $video" >&2
  exit 1
fi

if ! command -v ffprobe >/dev/null 2>&1; then
  echo "[error] ffprobe is required but was not found in PATH." >&2
  exit 1
fi

duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$video")
read -r width height <<<"$(ffprobe -v error -select_streams v:0 \
  -show_entries stream=width,height -of csv=p=0 "$video" | tr ',' ' ')"

if [[ -z "${width:-}" || -z "${height:-}" || "$height" -eq 0 ]]; then
  echo "[error] no decodable video stream in $video" >&2
  exit 1
fi

echo "[info] duration=${duration}s resolution=${width}x${height}"

if [[ "$height" -lt 720 ]]; then
  echo "[warn] height ${height} < 720 — this may be a low-resolution preview, not the original."
fi

if [[ -n "$expected" ]]; then
  ok=$(python3 -c "
d, e = float('$duration'), float('$expected')
print('yes' if e > 0 and abs(d - e) / e <= 0.02 else 'no')
")
  if [[ "$ok" != "yes" ]]; then
    echo "[error] duration ${duration}s deviates more than 2% from expected ${expected}s — likely a partial download." >&2
    exit 1
  fi
  echo "[ok] duration matches expected ${expected}s within 2%"
fi

echo "[ok] media verification passed: $video"
