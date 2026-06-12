# Feishu Doc Minutes Preview Card

Use this when a document currently shows a bare Minutes link and the user wants the link shown as a preview/card block.

## UI steps

1. Open the Feishu doc in logged-in Chrome.
2. Scroll to the Minutes link.
3. Click or right-click the link to show the link edit menu.
4. Click `链接视图`.
5. In the submenu, click `预览视图`.
6. Wait for the card to load and for the header to show saved/cloud-synced.

## CDP-assisted steps

These commands assume the Claude Code web-access CDP proxy on `localhost:3456`. In other environments (MCP Playwright, Codex browser tools), run the same page JavaScript via that environment's evaluate/click tools — only the wrapper differs.

CSS selectors below may drift as Feishu updates its UI. If a selector stops matching, locate the element by its visible text (`预览视图` / `链接视图`) instead.

Find the doc target:

```bash
curl -s http://localhost:3456/targets
```

Right-click or context-click the Minutes anchor. If `/clickAt` opens the link instead of the menu, dispatch a context menu event in page JavaScript:

```bash
curl -s -X POST "http://localhost:3456/eval?target=DOC_TARGET" --data-binary @- <<'JS'
(async () => {
  const a = document.querySelector('a[href*="/minutes/"]');
  if (!a) return {error: 'no minutes link'};
  a.scrollIntoView({block: 'center'});
  const r = a.getBoundingClientRect();
  const opts = {bubbles:true, cancelable:true, view:window, clientX:r.x+10, clientY:r.y+10, button:2, buttons:2};
  for (const type of ['pointerover','mouseover','mousemove','pointerdown','mousedown','contextmenu','pointerup','mouseup']) {
    a.dispatchEvent(new MouseEvent(type, opts));
    await new Promise(res => setTimeout(res, 40));
  }
  return {ok: true};
})()
JS
```

Click `链接视图`, then click the inactive submenu item (`预览视图`):

```bash
curl -s -X POST "http://localhost:3456/clickAt?target=DOC_TARGET" -d '.panel-submenu-item'
curl -s -X POST "http://localhost:3456/clickAt?target=DOC_TARGET" -d '.docx-submenu-panel .panel-menu-item:not(.menu-item-actived)'
```

If selectors drift, inspect visible menu text and click by the element containing `预览视图`.

## Verification

Visual check:

```bash
curl -s "http://localhost:3456/screenshot?target=DOC_TARGET&file=/tmp/feishu_preview.png"
```

DOM check:

```bash
curl -s -X POST "http://localhost:3456/eval?target=DOC_TARGET" --data-binary @- <<'JS'
(() => ({
  hasPlainMinutesAnchor: !!document.querySelector('a[href*="/minutes/"]'),
  visibleText: document.body.innerText.match(/高清视频妙记[\s\S]{0,500}/)?.[0] || ''
}))()
JS
```

API check commonly shows an iframe-like block:

```bash
lark-cli api GET /open-apis/docx/v1/documents/DOC_ID/blocks \
  --as user --params '{"page_size":500,"document_revision_id":-1}' |
  jq '.data.items[] | select(.block_type==26)'
```

Feishu's public `link_preview` block API is not a reliable substitute here: public docs have limited link-preview creation support, while the UI can convert ordinary Minutes links into a preview block.
