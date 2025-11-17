# lama 小站 · Jekyll + GitHub Pages

一个围绕中文写作优化的静态博客，使用 Jekyll + Sass + 原生 ES Modules 构建，并集成 Static CMS 方便远程投稿。

**线上访问:** https://lllllllama.me

[![Deploy](https://github.com/lllllllama/blog_web/actions/workflows/deploy.yml/badge.svg)](https://github.com/lllllllama/blog_web/actions/workflows/deploy.yml)

---

## 🚀 快速开始

**3 分钟部署你的博客！**

```bash
# 1. 初始化环境
make setup

# 2. 本地预览
make serve

# 3. 一键部署
make deploy
```

📖 **详细文档:**
- [快速开始指南](QUICKSTART.md) - 3 分钟快速上手
- [部署指南](DEPLOY.md) - 完整的部署说明和常见问题

### 跨平台支持

**Linux / macOS:**
```bash
./scripts/setup.sh      # 初始化
./scripts/serve.sh      # 本地预览
./scripts/deploy.sh     # 部署
```

**Windows (PowerShell):**
```powershell
.\scripts\setup.ps1     # 初始化
.\scripts\serve.ps1     # 本地预览
```

**使用 Makefile:**
```bash
make help              # 查看所有命令
```

---

## 目录结构

```
.
├── _config.yml              # 站点配置
├── _layouts/                # 页面布局模板（default/post/page 等）
├── _includes/               # 模板片段（head/header/footer/meta/search/toc 等）
├── _sass/                   # Sass 样式模块与设计令牌
├── assets/                  # 样式、脚本、图片与其它静态资源
├── _posts/                  # 博文内容（Markdown）
├── pages/                   # 独立页面（about / archives / tags 等）
├── admin/                   # Static CMS 后台（路径 /admin/）
├── scripts/                 # PowerShell 工具脚本
└── .github/workflows/       # GitHub Actions 配置
```

---

## Static CMS 后台 & 开放投稿

- 后台入口：`/admin/`
- 配置要点：
  - `publish_mode: editorial_workflow`：投稿先进入审核队列。
  - `open_authoring: true`：启用开放投稿（fork + PR 流程）。
  - 通过 Render 部署的 GitHub OAuth 代理，回调为 `/callback`。

开放投稿前提：
- 仓库需设为 Public，否则未授权用户会看到 “Repo not found”。
- 建议开启分支保护：必须通过 PR、需 Code Owners 审核，部署前自选状态检查。
- `.github/CODEOWNERS` 可以指定 `_posts/**`、`pages/**`、`admin/**` 对应的审核人。

投稿流程：
1. 投稿者访问 `https://<你的域名>/admin/` 并使用 GitHub 登录。
2. 新建或编辑文章后点击「保存」→「提交以审核」。
3. CMS 会在投稿者名下 fork 仓库并发起 PR。
4. 仓库维护者在 GitHub 审核合并后即可触发 Pages 自动部署。

详细说明见 `docs/OPEN_AUTHORING.md`。

---

## 写作与发布

- 新文章：`_posts/YYYY-MM-DD-slug.md`，必要字段：
  - `layout: post`
  - `title`, `date`, `categories`, `tags`
  - `pin`（首页置顶）、`toc`（目录）
  - `summary`（首页卡片摘要，可留空让 Jekyll 自动截断）
- PowerShell 辅助脚本（Windows）：
  - `scripts\new-post.ps1` 快速生成文章。
  - `scripts\first-push.ps1` 设置远端并完成首次推送。
- 静态资源：
  - 文章封面默认 `/assets/img/cover.svg`，可自定义。
  - 图库与附件字段可在 Static CMS 中直接上传。

---

## 部署

1. 仓库 Settings → Pages 中选择 “GitHub Actions” 作为部署源（仓库已包含 `pages.yml`）。
2. 默认构建模式为 B（Bundler 自定义构建）；可通过 `BUILD_MODE` 切换到官方构建。
3. 成功部署后可在 Pages 设置中绑定自定义域名（记得配置 DNS 并开启 HTTPS）。

GitHub Actions 流程：
- `pages.yml`：负责构建与部署。
- `ci.yml`：在指定分支/PR 上执行 Jekyll 构建、HTMLProofer、pa11y、Lighthouse。
- `lint.yml`：非阻塞的额外检查（htmlproofer、markdownlint、stylelint）。

---

## 常见问题

- **后台提示 Repo not found**：仓库非公开或登录账户无访问权限。
- **登录 403/CORS**：更新 OAuth 代理的 `ORIGINS` 环境变量，包含 `https://<域名>` 与 `https://www.<域名>`。
- **页面空白或样式异常**：强制刷新（Ctrl/Cmd + Shift + R）以清理缓存。
- **SSL/证书问题（Windows）**：运行 `ridk install` 并更新证书后重试。

---

## 授权协议

MIT License
