# 赛博朋克风 Jekyll + GitHub Pages（Windows 友好）

一套生产级、可演进的赛博朋克主题博客脚手架：默认深色（#0b0e14），霓虹点缀（青/洋红/酸橙/紫），轻量动效与 HUD 元素。无打包器，仅用 Jekyll + Sass + 原生 ES Modules；兼容 GitHub Pages 官方构建（A 模式）。

适用环境：Windows 10/11，PowerShell 5+；已安装 Ruby（含 DevKit/MSYS2）。

---

## 一键开始（Windows）

1) 打开 PowerShell，切换到项目目录。

2) 安装依赖并初始化（如首次）：

```powershell
scripts\setup.ps1
```

可选：从模板仓库拉取/合并（仅复制不存在的文件，不覆盖）

```powershell
scripts\setup.ps1 -TemplateRepoUrl "https://github.com/<org>/<template-repo>.git"
# 或设置环境变量：$env:TEMPLATE_REPO_URL="..." 后直接运行 scripts\setup.ps1
```

3) 本地预览（带自动刷新）：

```powershell
scripts\serve.ps1
# 默认 http://127.0.0.1:4000 访问；
# 如端口被占用：$env:JEKYLL_PORT=4001; scripts\serve.ps1
```

---

## 目录结构

```
.
├─ _config.yml              # 站点配置（中文/上海时区/分页/SEO 等）
├─ _layouts/                # 页面布局（default/post/page）
├─ _includes/               # 片段（head/header/footer/meta/search/toc/theme-toggle/comments）
├─ _sass/                   # 设计令牌 + 基础 + 组件（可演进）
├─ assets/                  # 样式、ESM 组件与动效、图片、favicon/logo
├─ _posts/                  # 示例文章（2 篇，含置顶/标签/分类）
├─ pages/                   # about、archives 页面
├─ .github/workflows/       # pages.yml（A/B 构建模式）
├─ scripts/                 # PowerShell 一键脚本
├─ Gemfile                  # 默认 A 模式：github-pages 依赖
├─ CNAME                    # 自定义域名（可留空或写入你的域名）
├─ .gitignore
├─ .gitattributes
├─ LICENSE (MIT)
└─ index.html               # 首页：英雄区 + 文章流 + 侧栏
```

---

## 模板选择（TEMPLATE_REPO_URL）

- 在首次运行 `scripts\setup.ps1` 时提供 `-TemplateRepoUrl`，或设置环境变量 `TEMPLATE_REPO_URL`。
- 脚本会临时克隆模板仓库，把文件复制到当前项目（跳过已存在同名文件，避免覆盖）。
- 复制后，你仍可在 `_config.yml` 中覆盖配置。

---

## GitHub 仓库与 Pages 设置

你可以选择：

- 用户页（User Page）：仓库名必须是 `<username>.github.io`
  - `_config.yml` 中设置：
    - `url: "https://<username>.github.io"`
    - `baseurl: ""`（留空）
- 项目页（Project Page）：任意仓库名，如 `blog`
  - `_config.yml` 中设置：
    - `url: "https://<username>.github.io"`
    - `baseurl: "/blog"`（仓库名，前面带 `/`）

首次推送到 GitHub：

```powershell
scripts\first-push.ps1 -Repo "https://github.com/<username>/<repo>.git"
```

Pages 部署源：本项目使用 GitHub Actions 进行部署（pages.yml 已包含）。进入仓库 Settings -> Pages，将 "Build and deployment" 的 Source 选择为 "GitHub Actions"。

---

## 两种构建模式（A 官方 / B 自建）

默认 A 模式：由官方 Jekyll Build Action 构建（等同 Pages 官方环境）。适用于只使用 GitHub Pages 白名单插件的场景：

- 使用的 Gems：`github-pages`（包含 jekyll、jekyll-seo-tag、jekyll-feed、jekyll-sitemap、jekyll-paginate 等)
- 工作流：`.github/workflows/pages.yml` 使用 `actions/jekyll-build-pages@v1` 构建并部署。

何时选择 B 模式（自行构建）：

- 需要使用 GitHub Pages 未支持的插件，或希望自行控制 Ruby/Jekyll 版本。

切换步骤：

1) 修改 `Gemfile`：
   - 注释/移除 `gem "github-pages"`；
   - 添加：
     ```ruby
     gem "jekyll", "~> 4.3"
     gem "jekyll-feed"
     gem "jekyll-seo-tag"
     gem "jekyll-sitemap"
     gem "jekyll-paginate"
     gem "rouge"
     group :development do
       gem "webrick", "~> 1.8"
     end
     ```
2) 修改工作流：打开 `.github/workflows/pages.yml`，将顶端 `env: BUILD_MODE: A` 改为 `B`。
3) 提交变更并推送，Actions 将在 B 模式下执行 `bundle exec jekyll build`，并发布 `_site` 产物。

---

## 写作指南（Front‑matter）

- 新建文章：

  ```powershell
  scripts\new-post.ps1 -Title "中文标题" -Slug "可选自定义-slug"
  ```

  生成文件：`_posts/YYYY-MM-DD-slug.md`，默认字段：
  - `layout: post`
  - `title`、`date`（自动）
  - `categories`、`tags`（参数 `-Cats`/`-Tags` 支持逗号分隔）
  - `pin: true|false`（置顶）
  - `cover`（封面路径，默认 `/assets/img/cover.svg`）
  - `summary`（摘要）
  - `toc: true|false`（文章目录）

- Front-matter 常见字段：
  - `layout: post|page`
  - `title: 标题`
  - `date: 2025-01-01 10:00:00 +0800`
  - `categories: [技术, Jekyll]`（多级分类）
  - `tags: [Jekyll, GitHub Pages]`
  - `pin: true|false`（首页置顶）
  - `excerpt: 自定义摘要`

- 代码高亮：已启用 Rouge，内置霓虹暗黑配色，含复制按钮。
- 图片路径：建议使用相对路径，如 `![alt](/assets/img/cover.svg)`；项目页注意 `baseurl` 影响。
- 草稿：可在 `_drafts/` 写草稿（需自建目录），本地 `jekyll serve --drafts` 预览。

---

## 主题/样式/动效（Design Tokens）

- 主题切换：右上角彩色芯片（C/M/L/V），`data-theme="cyber-*"`；记忆在 localStorage。
- 设计令牌：`_sass/_tokens.scss` 集中定义颜色、阴影、圆角、动效时间与 easing（`cubic-bezier(0.22, 1, 0.36, 1)`）。
- 动效准则：
  - Hover/Focus：120–180ms；入场：240–360ms；大块区域：~520ms。
  - `prefers-reduced-motion: reduce` 下自动弱化/禁用动效与视差。
- 组件：按钮、卡片、搜索面板、TOC、代码块等对应 `_sass/components/` 与 `assets/js/components/`。

- 修改导航/社交：`_config.yml` 的 `nav` / `social`。
- 深浅色模式：右上角切换；JS 在 `assets/js/darkmode.js`，样式变量在 `_sass/_base.scss`。
- 样式入口：`assets/css/main.scss`，可在 `_sass/` 下扩展与拆分模块。
- 布局模板：`_layouts/` 与 `_includes/` 可按需调整。

---

## 自定义域名（CNAME）

1) 在仓库 Settings -> Pages 中设置自定义域名。
2) 将仓库根目录 `CNAME` 文件内容改为你的域名（如 `blog.example.com`）。
3) 在 DNS 提供商处配置 A/AAAA 或 CNAME 记录，参考 GitHub 文档。

---

## 常见问题（Windows）

- ridk/MSYS2 依赖：如果编译本地原生扩展失败，运行 `ridk install` 选择 1/2/3 安装更新所需组件。
- 端口占用：4000 被占用时，可 `setx JEKYLL_PORT 4001` 或 `powershell: $env:JEKYLL_PORT=4001; scripts\serve.ps1`。
- RubyGems 下载慢：可临时使用镜像，例如 `gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/`（按需自行选择）。
- invalid byte sequence in GBK：请确保文件编码为 UTF-8（无 BOM），路径不要包含中文或空格；脚本已用 UTF-8 写入。
- SSL 证书/代理：如 `gem` 或 `bundle` 下载失败，检查代理/证书；尝试 `ridk install` 更新证书，或 `git config --global http.sslBackend schannel` 使用系统证书。

---

## 发布流程

1) 本地预览：`scripts\serve.ps1`，确认效果。
2) 推送：`scripts\first-push.ps1 -Repo "https://github.com/<username>/<repo>.git"`
3) GitHub Pages：仓库 Settings -> Pages 选择 "GitHub Actions"；查看 Actions 运行日志；完成后在 Pages 环境查看部署 URL。

---

## 性能与质量

- 预算：主页总传输 ≤ 250KB gz；首屏 CSS ≤ 40KB gz；JS ≤ 60KB gz。
- 优化策略：
  - 关键 CSS（上折叠）内联于 `<head>` 少量，其余延迟。
  - 图片懒加载、`decoding="async"`、必要的 `width/height`；优先 `webp/avif`。
  - JS 模块按需懒加载（搜索、TOC、动效）。
  - 资源指纹：可用查询串版本（例如 `main.css?v=YYYYMMDD`），并设置长缓存；按需在 Actions 中自动替换（后续 Roadmap）。
- 质量门禁（可选）：`.github/workflows/lint.yml` 运行 htmlproofer、markdownlint、stylelint，continue-on-error 仅报警。

## Lighthouse 建议

- 使用 Chrome DevTools Lighthouse 跑 Performance、A11y、SEO。
- 常见扣分：图片尺寸/格式、CLS（图片需 width/height）、无效链接、低对比度。

## Roadmap（可演进）

- [ ] 3D 背景（WebGL/Three.js，默认关闭）。
- [ ] Mermaid/轻量图表（纯前端，A 模式可用）。
- [ ] 多主题包（四种霓虹主题可热切换，记忆在 localStorage）。
- [ ] 多语言 i18n。
- [ ] PWA（离线缓存静态页，默认关闭）。
- [ ] 站点地图可视化/标签关系图谱（默认关闭）。

默认使用 MIT 许可证（见 `LICENSE`），可按需修改。

---

## 附：本地与 Actions 配置一致性检查

- `Gemfile`：默认启用 `github-pages`（A 模式）。若切至 B 模式，请移除 `github-pages`，添加 `jekyll` 及需要的插件，并把工作流 `BUILD_MODE` 改为 `B`。
- `_config.yml`：
  - 用户页 `baseurl` 留空；项目页设置为 `/<repo>`。
  - `timezone: Asia/Shanghai` 可改。
  - 导航/社交配置在 `nav`/`social`。
- `.github/workflows/pages.yml`：
  - A 模式：`actions/jekyll-build-pages` + `github-pages` 集合。
  - B 模式：`ruby/setup-ruby` + `bundle exec jekyll build`。
```
