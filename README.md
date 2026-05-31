# 飞书妙记视频纪要蒸馏助手 / feishu-minutes-video-clone

中文 | [English](README.en.md)

`feishu-minutes-video-clone` 是一个面向会议、培训和录屏资料沉淀的 Skill。它把飞书/Lark 妙记或本地会议视频整理成高清视频、中文字幕、结构化纪要文档和可预览的视频入口。

“蒸馏”强调从长视频和长 transcript 中提取真正可用的结论、行动项、时间线和知识片段。

## 适合场景

- 会议结束后生成可分享的纪要文档。
- 把妙记视频下载为本地高清版本。
- 给培训或录屏视频添加中文字幕。
- 将会议视频上传为新的高清妙记入口。
- 把裸链接切换成飞书文档中的预览卡片。

## 核心能力

- 提取妙记 token、元数据、AI 摘要和 transcript。
- 通过登录浏览器定位受保护视频资源。
- 使用 ffmpeg 封装或烧录中文字幕。
- 生成结构化飞书纪要文档。
- 上传高清字幕视频并切换预览卡片入口。
- 验证文档中不泄露原始妙记链接和过程说明。

## 目录

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

## 快速检查

```bash
python3 scripts/validate_skill_package.py --zip
bash -n scripts/mux_subtitles.sh
```

## Skill 安装

Skill 分发包位置：

```text
skill/feishu-minutes-video-clone/feishu-minutes-video-clone.zip
```

安装到本地 Skill 目录：

```bash
mkdir -p ~/.codex/skills
unzip -o skill/feishu-minutes-video-clone/feishu-minutes-video-clone.zip -d ~/.codex/skills/
```

## License

MIT
