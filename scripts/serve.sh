#!/usr/bin/env bash
# 本地预览脚本 - 适用于 Linux/macOS
# 用法: ./scripts/serve.sh

set -e

info() { echo -e "\033[0;36m[INFO]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

# 检查 Gemfile
if [ ! -f Gemfile ]; then
    error "未找到 Gemfile。请在项目根目录运行此脚本。"
fi

# 获取端口和主机配置
JEKYLL_PORT=${JEKYLL_PORT:-4000}
JEKYLL_HOST=${JEKYLL_HOST:-127.0.0.1}
URL="http://${JEKYLL_HOST}:${JEKYLL_PORT}"

info "启动 Jekyll 预览服务器: $URL"
info "按 Ctrl+C 停止服务器"
echo ""

# 启动 Jekyll 服务器
bundle exec jekyll serve \
    --livereload \
    --host "$JEKYLL_HOST" \
    --port "$JEKYLL_PORT" \
    --open-url
