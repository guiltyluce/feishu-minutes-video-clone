#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  mux_subtitles.sh INPUT.mp4 SUBTITLES.srt OUTPUT.mp4 [--burn-in]

Default mode adds SUBTITLES.srt as a soft Chinese subtitle track without
re-encoding the video/audio. Use --burn-in to render subtitles into pixels.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 3 || $# -gt 4 ]]; then
  usage >&2
  exit 2
fi

input=$1
subs=$2
output=$3
mode=${4:-}

if [[ ! -f "$input" ]]; then
  echo "Input video not found: $input" >&2
  exit 1
fi

if [[ ! -f "$subs" ]]; then
  echo "Subtitle file not found: $subs" >&2
  exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is required but was not found in PATH." >&2
  exit 1
fi

case "$mode" in
  "")
    ffmpeg -hide_banner -y \
      -i "$input" -i "$subs" \
      -map 0 -map 1 \
      -c copy -c:s mov_text \
      -metadata:s:s:0 language=chi \
      -metadata:s:s:0 title="Chinese subtitles" \
      "$output"
    ;;
  "--burn-in")
    ffmpeg -hide_banner -y \
      -i "$input" \
      -vf "subtitles=${subs}:force_style='FontName=PingFang SC,FontSize=18,Outline=1,Shadow=0,MarginV=28'" \
      -c:v libx264 -crf 18 -preset medium \
      -c:a copy \
      "$output"
    ;;
  *)
    echo "Unknown option: $mode" >&2
    usage >&2
    exit 2
    ;;
esac

if command -v ffprobe >/dev/null 2>&1; then
  ffprobe -hide_banner -loglevel error -show_entries format=duration,size -show_streams "$output" >/dev/null
fi
