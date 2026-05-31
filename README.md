# 飞书妙记视频纪要蒸馏助手 / feishu-minutes-video-clone

`feishu-minutes-video-clone` 是一个面向会议、培训和录屏资料沉淀的 Skill。它把飞书/Lark 妙记或本地会议视频整理成高清视频、中文字幕、结构化纪要文档和可预览的视频入口。

`feishu-minutes-video-clone` is a Skill for preserving meeting, training, and screen-recording assets. It turns Feishu/Lark Minutes or local meeting videos into high-resolution video, Chinese subtitles, structured summary documents, and previewable video entries.

“蒸馏”强调从长视频和长 transcript 中提取真正可用的结论、行动项、时间线和知识片段。

"Distillation" here means extracting useful conclusions, action items, timelines, and knowledge fragments from long videos and transcripts.

## 适合场景 / Use Cases

- 会议结束后生成可分享的纪要文档。
- Create shareable meeting summary documents after meetings.
- 把妙记视频下载为本地高清版本。
- Save Feishu Minutes videos as local high-resolution files.
- 给培训或录屏视频添加中文字幕。
- Add Chinese subtitles to training or screen-recording videos.
- 将会议视频上传为新的高清妙记入口。
- Upload a high-resolution meeting video as a new Minutes entry.
- 把裸链接切换成飞书文档中的预览卡片。
- Convert plain links into preview cards inside Feishu documents.

## 核心能力 / Core Capabilities

- 提取妙记 token、元数据、AI 摘要和 transcript。
- Extract Minutes tokens, metadata, AI summaries, and transcripts.
- 通过登录浏览器定位受保护视频资源。
- Locate protected video resources through a logged-in browser session.
- 使用 ffmpeg 封装或烧录中文字幕。
- Use ffmpeg to mux or burn Chinese subtitles.
- 生成结构化飞书纪要文档。
- Generate structured Feishu meeting-summary documents.
- 上传高清字幕视频并切换预览卡片入口。
- Upload high-resolution subtitled videos and switch the document entry to a preview card.
- 验证文档中不泄露原始妙记链接和过程说明。
- Verify that the final document does not expose the original Minutes link or process notes.

## 目录 / Repository Layout

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

## 快速检查 / Quick Check

```bash
python3 scripts/validate_skill_package.py --zip
bash -n scripts/mux_subtitles.sh
```

## Skill 安装 / Skill Installation

Skill 分发包位置：

The distributable Skill package is located at:

```text
skill/feishu-minutes-video-clone/feishu-minutes-video-clone.zip
```

安装到本地 Skill 目录：

Install it into the local Skill directory:

```bash
mkdir -p ~/.codex/skills
unzip -o skill/feishu-minutes-video-clone/feishu-minutes-video-clone.zip -d ~/.codex/skills/
```

## License

MIT
