---
layout: post
title: 第二篇：标签/分类/摘要/代码高亮演示
date: 2024-02-01 09:30:00 +0800
categories: [技术, Jekyll]
tags: [Jekyll, GitHub Pages, SEO]
cover: /assets/img/cover.svg
summary: 本文演示更多的 front-matter 字段用法与列表摘要效果，同时展示 Rouge 代码高亮的样式效果。
toc: true
---

这是一篇更完整的演示文章，包含以下内容：

- 分类与标签（用于归档与检索）。
- 摘要（excerpt）与首页卡片展示。
- Rouge 代码高亮（Ruby、JavaScript 等）。

```js
function sum(a, b) {
  return a + b;
}
console.log(sum(1, 2));
```

```yaml
plugins:
  - jekyll-seo-tag
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-paginate
```

如果要启用不在 GitHub Pages 白名单中的插件，请切换到 B 模式（自行构建）。详见 README 的构建模式说明。
