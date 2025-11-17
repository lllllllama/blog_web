# 快速开始

3 分钟快速部署你的博客到 GitHub Pages。

## 1. 环境准备

确保已安装：
- Ruby 3.0+ （推荐 3.3）
- Git

## 2. 初始化

```bash
# 克隆仓库
git clone https://github.com/lllllllama/blog_web.git
cd blog_web

# 一键设置环境
make setup
```

## 3. 本地预览

```bash
# 启动本地服务器
make serve

# 访问 http://127.0.0.1:4000
```

## 4. 创建文章

```bash
# 创建新文章
make new-post

# 编辑文章
vim _posts/2025-11-17-my-first-post.md
```

## 5. 部署

```bash
# 一键部署到 GitHub Pages
make deploy
```

等待 2-3 分钟，访问你的网站：https://lllllllama.me

## 常用命令

```bash
make help        # 查看帮助
make setup       # 初始化环境
make serve       # 本地预览
make new-post    # 创建文章
make deploy      # 一键部署
make clean       # 清理文件
```

## 下一步

- 📝 [部署指南](DEPLOY.md) - 详细的部署说明
- ⚙️ [配置说明](_config.yml) - 自定义你的博客
- 🎨 [主题定制](_sass/_tokens.scss) - 修改颜色和样式

---

**遇到问题？** 查看 [部署指南](DEPLOY.md) 的常见问题部分。
