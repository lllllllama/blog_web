#!/usr/bin/env bash
# 创建新文章脚本 - 适用于 Linux/macOS
# 用法: ./scripts/new-post.sh "文章标题"

set -e

info() { echo -e "\033[0;36m[INFO]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }
success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }

# 获取文章标题
if [ -z "$1" ]; then
    read -p "请输入文章标题: " TITLE
else
    TITLE="$1"
fi

if [ -z "$TITLE" ]; then
    error "文章标题不能为空"
fi

# 生成文件名
DATE=$(date +%Y-%m-%d)
SLUG=$(echo "$TITLE" | iconv -t ascii//TRANSLIT | sed -r 's/[^a-zA-Z0-9]+/-/g' | sed -r 's/^-+\|-+$//g' | tr A-Z a-z)
FILENAME="_posts/${DATE}-${SLUG}.md"

# 检查文件是否已存在
if [ -f "$FILENAME" ]; then
    error "文件已存在: $FILENAME"
fi

# 创建文章
info "创建新文章: $FILENAME"

cat > "$FILENAME" << EOF
---
layout: post
title: "${TITLE}"
date: $(date +"%Y-%m-%d %H:%M:%S %z")
categories: []
tags: []
pin: false
toc: true
summary: ""
---

## 简介

在这里写文章内容...

## 正文

### 子标题

内容...

## 总结

总结内容...
EOF

success "✓ 文章创建成功: $FILENAME"
echo ""
info "下一步:"
echo "  1. 编辑文章: $FILENAME"
echo "  2. 本地预览: ./scripts/serve.sh"
echo "  3. 部署发布: ./scripts/deploy.sh \"Add: $TITLE\""
