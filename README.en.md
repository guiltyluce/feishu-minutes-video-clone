# Feishu Minutes Video Distiller / feishu-minutes-video-clone

[中文](README.md) | English

`feishu-minutes-video-clone` is a Skill for preserving meeting, training, and screen-recording assets. It turns Feishu/Lark Minutes or local meeting videos into high-resolution video, Chinese subtitles, structured summary documents, and previewable video entries.

"Distillation" here means extracting useful conclusions, action items, timelines, and knowledge fragments from long videos and transcripts.

## Use Cases

- Create shareable meeting summary documents after meetings.
- Save Feishu Minutes videos as local high-resolution files.
- Add Chinese subtitles to training or screen-recording videos.
- Upload a high-resolution meeting video as a new Minutes entry.
- Convert plain links into preview cards inside Feishu documents.

## Core Capabilities

- Extract Minutes tokens, metadata, AI summaries, and transcripts.
- Locate protected video resources through a logged-in browser session.
- Use ffmpeg to mux or burn Chinese subtitles.
- Generate structured Feishu meeting-summary documents.
- Upload high-resolution subtitled videos and switch the document entry to a preview card.
- Enforce post-download checks on duration and resolution, rejecting partial downloads and low-res preview streams.
- Verify that the final document does not expose the original Minutes link or process notes.

## Repository Layout

```text
.
├── README.md
├── LICENSE
├── references/
│   ├── media-extraction.md
│   └── preview-card.md
├── scripts/
│   ├── mux_subtitles.sh
│   ├── verify_media.sh
│   ├── install.sh
│   ├── package.sh
│   └── validate_skill_package.py
└── skill/
    └── feishu-minutes-video-clone/
        ├── SKILL.md
        └── feishu-minutes-video-clone.zip
```

## Quick Check

```bash
python3 scripts/validate_skill_package.py --zip
bash -n scripts/mux_subtitles.sh scripts/verify_media.sh
```

## Skill Installation

SKILL.md is a cross-agent standard; the same package works in multiple environments.

Local CLIs (installs into Claude Code `~/.claude/skills/` and Codex `~/.codex/skills/`):

```bash
bash scripts/install.sh
```

Upload-style platforms (claude.ai Skills, WorkBuddy, etc.): upload the rebuilt package

```bash
bash scripts/package.sh   # rebuilds skill/feishu-minutes-video-clone/feishu-minutes-video-clone.zip
```

## License

MIT
