---
name: feishu-minutes-video-clone
description: 飞书妙记视频纪要蒸馏助手：把飞书/Lark 妙记或本地会议视频整理成高清视频、中文字幕、结构化纪要文档和可预览入口；适用于会议复盘、培训沉淀、视频知识库和交付型纪要场景。
---

# 飞书妙记视频纪要蒸馏助手

GitHub: [guiltyluce/feishu-minutes-video-clone](https://github.com/guiltyluce/feishu-minutes-video-clone)

用于把飞书/Lark 妙记录制或本地会议视频蒸馏成可交付材料：本地高清视频、中文字幕、结构化纪要文档、新上传的高清妙记，以及文档中的预览卡片入口。

# 触发场景

用户出现以下意图时使用：

- 下载或保存飞书妙记视频。
- 给会议视频添加中文字幕。
- 根据妙记 transcript 生成飞书纪要文档。
- 上传高清字幕视频为新的妙记条目。
- 将文档里的妙记链接切换为预览卡片。
- 把录屏、培训或会议整理成可分享材料。

# 所需工具

- `lark-cli`：读取妙记元数据、会议纪要、文档创建和更新。
- `web-access` 或浏览器自动化：处理登录态页面、受保护媒体资源和预览卡切换。
- `ffmpeg` / `ffprobe`：下载、验证和封装字幕视频。
- `scripts/mux_subtitles.sh`：软字幕封装和可选烧录字幕。

# 工作流程

1. 确认输入和隐私规则：
   - 从 `https://.../minutes/<minute_token>` 提取 token。
   - 原始妙记 URL 默认不写入最终文档。
   - 本地文件名使用中性标题，不暴露敏感会议 token。
2. 获取元数据和 AI 产物：
   - 使用 `lark-cli minutes` 获取标题、时长等基础信息。
   - 使用 `lark-cli vc +notes` 导出 summary、chapters、todos 和 transcript。
3. 下载或提取视频：
   - 优先使用用户提供的本地视频。
   - 否则用登录浏览器检查 `<video>`、`.mp4`、`.m3u8`、字幕资源和 signed URL。
   - 参考 `references/media-extraction.md`。
4. 准备中文字幕：
   - 优先使用带时间轴的 `.srt` / `.vtt`。
   - 只有无时间轴文本时，不静默伪造字幕时间；需说明限制或请求确认。
   - 使用 `scripts/mux_subtitles.sh` 合成中文字幕视频。
5. 生成飞书纪要文档：
   - 默认结构：简介、一页结论、内容归纳、行动清单、时间线、高清视频妙记。
   - 避免把原始妙记 URL、临时下载链接和过程说明写入文档。
6. 上传高清字幕视频：
   - 上传为新的飞书妙记或平台支持的视频入口。
   - 在纪要文档中放置新的预览入口。
7. 切换预览卡片：
   - 参考 `references/preview-card.md`。
   - 验证最终文档呈现为预览卡片，并避开裸链接或压缩附件。

# 关键命令

字幕封装：

```bash
bash scripts/mux_subtitles.sh \
  video.mp4 zh-CN.srt video.中文字幕.mp4
```

媒体验证：

```bash
ffprobe -hide_banner -show_streams -show_format video.中文字幕.mp4
```

# 注意事项

- 默认使用用户身份读取和写入飞书内容。
- 不在最终文档中泄露原始妙记 URL、临时 signed URL 或下载过程。
- 不打印 app secret、tenant token、cookie 或受保护媒体 URL。
- 视频下载失败时，报告失败阶段和可替代方案。
- 字幕时间轴不足时，明确说明，不编造精确时间。
