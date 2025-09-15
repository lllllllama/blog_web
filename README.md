# lama小站 · Jekyll + GitHub Pages

一个简洁可演进的静态博客。技术栈：Jekyll + Sass + 原生 ES Modules，部署在 GitHub Pages；管理端集成 Static CMS（支持开放投稿、审核发布）。

在线地址：`https://lllllllama.me`

——

## 快速开始（本地预览）

1) 安装 Ruby（含 DevKit/MSYS2）与 Bundler（Windows 可直接用仓库脚本）
2) 进入仓库目录并运行：

```powershell
scripts\setup.ps1    # 安装依赖（首次）
scripts\serve.ps1    # 本地预览，默认 http://127.0.0.1:4000
```

——

## 目录结构

```
.
├─ _config.yml              # 站点配置
├─ _layouts/                # 页面布局（default/post/page）
├─ _includes/               # 片段（head/header/footer/meta/search/toc 等）
├─ _sass/                   # 设计令牌/基础/组件样式
├─ assets/                  # 样式、图片、JS
├─ _posts/                  # 文章
├─ pages/                   # about、archives 等页面
├─ admin/                   # Static CMS 后台（/admin/）
├─ .github/workflows/       # Pages 部署工作流
└─ index.html               # 首页
```

——

## 在线后台 · Static CMS（开放投稿）

- 后台地址：`/admin/`
- 已启用：
  - `publish_mode: editorial_workflow`（草稿 → 审核 → 发布）
  - `open_authoring: true`（开放投稿：任何 GitHub 用户可登录并通过 fork + PR 投稿）
  - GitHub OAuth 代理：Render 托管，回调为 `/callback`

开启开放投稿前提（必须）
- 仓库必须是 Public（公开）。否则未授权用户会看到 “Repo not found”。
- 分支保护（建议）
  - Require a pull request before merging
  - Require review from Code Owners
  - 可选：Require status checks（Pages 构建）
- CODEOWNERS：`.github/CODEOWNERS` 指定 `@lllllllama` 审核 `_posts/**`、`pages/**`、`admin/**`

投稿与审核流程
1. 访问 `https://<你的域名>/admin/` 用 GitHub 登录
2. 创建或编辑文章 → “保存” → “提交以审核”
3. CMS 在投稿者账户 fork 你的公开仓库并发起 PR
4. 你在 GitHub 审核合并，合并后 Pages 自动发布

更多细节见 `docs/OPEN_AUTHORING.md`

——

## 写作与上传

- 文章：`_posts/YYYY-MM-DD-slug.md`
- Front‑matter 常用字段：
  - `layout: post`
  - `title: 标题`
  - `date: yyyy-MM-dd HH:mm:ss +0800`
  - `categories: [分类]`
  - `tags: [标签]`
  - `pin: true|false`（首页置顶）
  - `toc: true|false`（目录）

- 后台上传：
  - 图片集（gallery）：多图 + 说明，页面自动以网格展示
  - 附件（attachments）：任意文件/PDF；勾选“内嵌预览”后 PDF 会内嵌显示并保留下载链接

——

## 自定义域名

1) Settings → Pages → Custom domain 填入你的域名，并启用 HTTPS
2) `CNAME` 文件内容写入该域名
3) DNS：A 记录指向 GitHub Pages IP（四个），`www` 用 CNAME 指向 `<username>.github.io`

——

## 常见问题

- 后台提示 “Repo not found”：仓库不是 Public，或登录账号无权访问私有仓库
- 登录 403/CORS：Render 代理 `ORIGINS` 必须包含 `https://<你的域名>` 与 `https://www.<你的域名>`
- 回调错误：GitHub OAuth App 的 Authorization callback URL 必须是 `https://<render域名>/callback`
- 后台空白：强制刷新（Ctrl/Cmd+Shift+R）；本仓库已引入官方 CSS 与正确初始化

——

## 许可证

MIT
