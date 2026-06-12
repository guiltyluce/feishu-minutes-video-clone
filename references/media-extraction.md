# Media Extraction Notes

Use this reference when a Feishu/Lark Minutes page does not expose a simple downloadable video URL.

## Required capability

You need a browser automation that can (a) reuse the user's logged-in Feishu session and (b) evaluate JavaScript in the page. Pick whatever the current environment provides:

- **Claude Code with the web-access skill**: start the CDP proxy via `bash ~/.claude/skills/web-access/scripts/check-deps.sh`, then use the `http://localhost:3456` endpoints shown below.
- **MCC Playwright / Codex / other agents**: open the Minutes URL in the logged-in browser and run the same JavaScript snippets through the environment's `evaluate` tool. The snippets are plain page JavaScript; only the invocation wrapper differs.

The examples below use the CDP proxy form. Translate mechanically for other environments.

## Browser-first approach

Open the Minutes page in the logged-in browser:

```bash
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

Always verify with the bundled script (duration vs Minutes metadata, resolution not a low-res preview):

```bash
bash scripts/verify_media.sh output.mp4 EXPECTED_DURATION_SECONDS
```

## Subtitle resources

Look for `.srt`, `.vtt`, JSON caption files, or transcript export from `lark-cli vc +notes`. Prefer timestamped sources. If only untimed transcript text is available, ask before running ASR or time alignment.
