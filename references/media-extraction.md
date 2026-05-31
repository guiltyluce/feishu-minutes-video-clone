# Media Extraction Notes

Use this reference when a Feishu/Lark Minutes page does not expose a simple downloadable video URL.

## Browser-first approach

Start the CDP proxy and use the user's logged-in Chrome:

```bash
bash ~/.claude/skills/web-access/scripts/check-deps.sh
curl -s "http://localhost:3456/targets"
curl -s "http://localhost:3456/new?url=MINUTES_URL"
```

Inspect DOM media and resource timing:

```bash
curl -s -X POST "http://localhost:3456/eval?target=TARGET_ID" --data-binary @- <<'JS'
(() => ({
  title: document.title,
  videos: [...document.querySelectorAll('video')].map(v => ({
    src: v.currentSrc || v.src,
    poster: v.poster,
    duration: v.duration,
    width: v.videoWidth,
    height: v.videoHeight,
    readyState: v.readyState
  })),
  tracks: [...document.querySelectorAll('track')].map(t => ({
    kind: t.kind,
    label: t.label,
    srclang: t.srclang,
    src: t.src
  })),
  resources: performance.getEntriesByType('resource')
    .map(e => e.name)
    .filter(u => /mp4|m3u8|m4s|vtt|srt|caption|subtitle|transcript|vod|tos|bytecdn|lark/i.test(u))
    .slice(-300)
}))()
JS
```

If the player lazy-loads resources, click play or seek with page JavaScript and inspect again:

```bash
curl -s -X POST "http://localhost:3456/eval?target=TARGET_ID" -d \
'(() => { const v=document.querySelector("video"); if (v) { v.muted=true; v.play().catch(()=>{}); } return !!v; })()'
```

## Download options

- Direct MP4: use `curl -L` or `ffmpeg -i URL -c copy output.mp4`.
- HLS/M3U8: use `ffmpeg -allowed_extensions ALL -i URL -c copy output.mp4`.
- Signed/protected URLs: preserve the exact URL and required headers. If simple `ffmpeg` fails, capture request headers from browser devtools/CDP or use browser cookies with `yt-dlp --cookies-from-browser chrome`.

Always verify:

```bash
ffprobe -hide_banner -show_streams -show_format output.mp4
```

Check that duration matches the Minutes metadata and that resolution is not a low-resolution preview.

## Subtitle resources

Look for `.srt`, `.vtt`, JSON caption files, or transcript export from `lark-cli vc +notes`. Prefer timestamped sources. If only untimed transcript text is available, ask before running ASR or time alignment.
