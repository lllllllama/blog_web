# Jekyll + GitHub Pages 博客骨架（Windows 友好）

本仓库是一套在 Windows 环境下可直接运行的 Jekyll + GitHub Pages 博客脚手架，包含：项目结构、中文示例内容、简洁响应式主题（含深浅色模式）、PowerShell 一键脚本，以及支持 A/B 两种构建模式的 GitHub Actions 工作流。

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
├─ _includes/               # 片段（head/header/footer/darkmode 按钮等）
├─ _sass/                   # Sass 局部样式
├─ assets/                  # 编译样式、JS、图片、favicon
├─ _posts/                  # 示例文章（2 篇，含置顶/标签/分类）
├─ pages/                   # about、archives 页面
├─ .github/workflows/       # pages.yml（A/B 构建模式）
├─ scripts/                 # PowerShell 一键脚本
├─ Gemfile                  # 默认 A 模式：github-pages 依赖
├─ CNAME                    # 自定义域名（可留空或写入你的域名）
├─ .gitignore
├─ .gitattributes
├─ LICENSE (MIT)
└─ index.html               # 首页：文章列表 + 网站介绍
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

## 写作指南

- 新建文章：

  ```powershell
  scripts\new-post.ps1 -Title "中文标题" -Slug "可选自定义-slug"
  ```

  生成文件：`_posts/YYYY-MM-DD-slug.md`，默认 front-matter：
  - `layout: post`
  - `title`、`date`（自动）
  - `categories: [随笔]`、`tags: [未分类]`
  - `pin: false`（置顶：设为 `true`）
  - `excerpt`（摘要，可留空使用自动截断）

- Front-matter 常见字段：
  - `layout: post|page`
  - `title: 标题`
  - `date: 2025-01-01 10:00:00 +0800`
  - `categories: [技术, Jekyll]`（多级分类）
  - `tags: [Jekyll, GitHub Pages]`
  - `pin: true|false`（首页置顶）
  - `excerpt: 自定义摘要`

- 代码高亮：已启用 Rouge；三引号代码块会高亮。
- 图片路径：建议使用相对路径，如 `![alt](/assets/img/cover.svg)`；项目页注意 `baseurl` 影响。
- 草稿：可在 `_drafts/` 写草稿（需自建目录），本地 `jekyll serve --drafts` 预览。

---

## 主题/样式自定义

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

## 许可证

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

# blog_web
