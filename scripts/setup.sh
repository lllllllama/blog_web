#!/usr/bin/env bash
# 一键设置脚本 - 适用于 Linux/macOS
# 用法: ./scripts/setup.sh

set -e

# 颜色输出
info() { echo -e "\033[0;36m[INFO]\033[0m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }
success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }

info "开始设置 Jekyll 博客环境..."

# 检查 Ruby 是否安装
if ! command -v ruby &> /dev/null; then
    error "未找到 Ruby。请先安装 Ruby 3.0 或更高版本。"
fi

RUBY_VERSION=$(ruby -v | awk '{print $2}' | cut -d'p' -f1)
info "检测到 Ruby 版本: $RUBY_VERSION"

# 检查并安装 Bundler
if ! command -v bundle &> /dev/null; then
    info "未找到 Bundler，正在安装..."
    gem install bundler --no-document
else
    info "Bundler 已安装"
fi

# 配置 bundle 路径
info "配置 bundle 安装路径 (vendor/bundle)"
bundle config set --local path 'vendor/bundle'

# 安装依赖
info "安装 Ruby 依赖包..."
bundle install --jobs 4 --retry 3

# 初始化 Git（如果需要）
if [ ! -d .git ]; then
    info "初始化 Git 仓库..."
    git init
    git checkout -b main
    git add -A
    git commit -m "chore: initial commit"
fi

success "✓ 环境设置完成！"
echo ""
info "可用命令:"
echo "  • 本地预览: ./scripts/serve.sh"
echo "  • 创建文章: ./scripts/new-post.sh"
echo "  • 一键部署: ./scripts/deploy.sh"
