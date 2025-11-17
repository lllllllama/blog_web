# 部署指南

本文档介绍如何快速部署 lama 小站到 GitHub Pages。

## 快速开始

### 方法一：一键部署（推荐）

```bash
# 1. 首次使用，初始化环境
make setup

# 2. 本地预览（可选）
make serve

# 3. 一键部署
make deploy
```

### 方法二：使用脚本

**Linux / macOS:**

```bash
# 初始化环境
./scripts/setup.sh

# 本地预览
./scripts/serve.sh

# 部署到 GitHub Pages
./scripts/deploy.sh "更新博客内容"
```

**Windows (PowerShell):**

```powershell
# 初始化环境
.\scripts\setup.ps1

# 本地预览
.\scripts\serve.ps1

# 手动提交并推送
git add -A
git commit -m "更新博客内容"
git push origin main
```

### 方法三：手动部署

```bash
# 1. 安装依赖
bundle install

# 2. 本地构建测试
bundle exec jekyll build

# 3. 提交更改
git add -A
git commit -m "更新内容"

# 4. 推送到 GitHub（自动触发部署）
git push origin main
```

## 部署流程说明

### 自动部署（推荐）

当你推送代码到 `main` 分支时，GitHub Actions 会自动：

1. ✅ 检出代码
2. ✅ 安装 Ruby 和依赖
3. ✅ 构建 Jekyll 网站
4. ✅ 部署到 GitHub Pages
5. ✅ 2-3 分钟后网站更新

你可以在这里查看部署进度：
```
https://github.com/lllllllama/blog_web/actions
```

### 本地预览

在部署前，建议先在本地预览：

```bash
# 启动本地服务器（带实时重载）
make serve

# 或者
./scripts/serve.sh

# 访问: http://127.0.0.1:4000
```

**自定义端口：**

```bash
JEKYLL_PORT=8080 make serve
```

## 创建新文章

### 快速创建

```bash
# 使用 Makefile
make new-post

# 或使用脚本
./scripts/new-post.sh "我的新文章标题"
```

这会在 `_posts/` 目录创建一个新文件，格式为：`YYYY-MM-DD-title-slug.md`

### 手动创建

1. 在 `_posts/` 目录创建文件：`2025-11-17-my-post.md`

2. 添加 Front Matter：

```yaml
---
layout: post
title: "我的新文章"
date: 2025-11-17 12:00:00 +0800
categories: [技术]
tags: [Jekyll, Blog]
pin: false
toc: true
summary: "文章简介"
---

文章内容...
```

3. 预览、提交、部署

## 常用命令

```bash
make help        # 查看所有可用命令
make setup       # 初始化环境
make serve       # 本地预览
make build       # 构建网站
make clean       # 清理构建文件
make deploy      # 一键部署
make new-post    # 创建新文章
make check       # 检查环境配置
```

## 环境要求

- **Ruby**: 3.0 或更高（推荐 3.3）
- **Bundler**: 2.0 或更高
- **Git**: 任意版本
- **操作系统**: Linux、macOS、Windows

### 安装 Ruby

**macOS:**
```bash
brew install ruby@3.3
```

**Ubuntu/Debian:**
```bash
sudo apt-get install ruby-full build-essential
```

**Windows:**
- 下载 [RubyInstaller](https://rubyinstaller.org/)
- 选择 Ruby 3.3.x (x64) with DEVKIT

## 常见问题

### 1. 端口被占用

```bash
# 使用其他端口
JEKYLL_PORT=8080 make serve
```

### 2. 依赖安装失败

```bash
# 清理并重新安装
bundle clean --force
make install
```

### 3. 部署失败

检查 GitHub Actions 日志：
1. 访问仓库的 Actions 标签页
2. 查看最近的工作流运行
3. 查看错误日志

### 4. 网站没有更新

- 等待 2-3 分钟（GitHub Pages 有缓存）
- 清除浏览器缓存
- 检查 Actions 是否成功完成

### 5. 权限错误（Linux/macOS）

```bash
# 添加执行权限
chmod +x scripts/*.sh
```

## 高级配置

### 自定义域名

1. 在仓库根目录创建 `CNAME` 文件
2. 添加你的域名：`blog.example.com`
3. 在域名提供商配置 DNS：
   ```
   CNAME  blog  lllllllama.github.io
   ```

### 环境变量

在 `~/.bashrc` 或 `~/.zshrc` 中设置：

```bash
export JEKYLL_PORT=8080
export JEKYLL_HOST=0.0.0.0  # 允许外部访问
```

### GitHub Pages 设置

1. 访问仓库 Settings → Pages
2. Source: GitHub Actions
3. 自动部署已启用

## 工作流说明

### 自动部署流程

```mermaid
graph LR
    A[本地修改] --> B[git commit]
    B --> C[git push]
    C --> D[GitHub Actions]
    D --> E[构建 Jekyll]
    E --> F[部署到 Pages]
    F --> G[网站更新]
```

### 文件结构

```
blog_web/
├── _posts/              # 博客文章
├── _config.yml          # Jekyll 配置
├── scripts/             # 部署脚本
│   ├── setup.sh         # 环境设置
│   ├── serve.sh         # 本地预览
│   ├── deploy.sh        # 一键部署
│   └── new-post.sh      # 创建文章
├── Makefile             # 快速命令
└── .github/workflows/
    └── deploy.yml       # 自动部署配置
```

## 贡献指南

1. Fork 仓库
2. 创建特性分支：`git checkout -b feature/new-feature`
3. 提交更改：`git commit -m "Add new feature"`
4. 推送分支：`git push origin feature/new-feature`
5. 创建 Pull Request

## 更多帮助

- [Jekyll 文档](https://jekyllrb.com/docs/)
- [GitHub Pages 文档](https://docs.github.com/pages)
- [项目 README](README.md)

---

**快速开始：**
```bash
make setup && make serve
```

**一键部署：**
```bash
make deploy
```
