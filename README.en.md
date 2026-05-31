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
│   └── validate_skill_package.py
└── skill/
    └── feishu-minutes-video-clone/
        ├── SKILL.md
        └── feishu-minutes-video-clone.zip
```

## Quick Check

```bash
python3 scripts/validate_skill_package.py --zip
bash -n scripts/mux_subtitles.sh
```

## Skill Installation

The distributable Skill package is located at:

```text
skill/feishu-minutes-video-clone/feishu-minutes-video-clone.zip
```

Install it into the local Skill directory:

```bash
mkdir -p ~/.codex/skills
unzip -o skill/feishu-minutes-video-clone/feishu-minutes-video-clone.zip -d ~/.codex/skills/
```

## License

MIT
