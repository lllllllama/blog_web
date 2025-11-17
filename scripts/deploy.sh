#!/usr/bin/env bash
# 一键部署脚本 - 部署到 GitHub Pages
# 用法: ./scripts/deploy.sh [commit-message]

set -e

# 颜色输出
info() { echo -e "\033[0;36m[INFO]\033[0m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }
success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }

# 获取提交信息
COMMIT_MSG="${1:-Update blog content}"

info "开始一键部署流程..."
echo ""

# 1. 检查 Git 状态
info "1/5 检查 Git 状态..."
if [ ! -d .git ]; then
    error "未找到 Git 仓库。请先运行 ./scripts/setup.sh"
fi

# 获取当前分支
CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
info "当前分支: $CURRENT_BRANCH"

# 2. 检查是否有未提交的更改
info "2/5 检查未提交的更改..."
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    warn "发现未提交的更改"

    # 显示更改的文件
    echo ""
    git status --short
    echo ""

    read -p "是否要提交这些更改? (y/N) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "添加所有更改到暂存区..."
        git add -A

        info "提交更改..."
        git commit -m "$COMMIT_MSG"
        success "✓ 更改已提交"
    else
        warn "跳过提交，使用现有的提交"
    fi
else
    info "工作目录干净，无需提交"
fi

# 3. 推送到远程仓库
info "3/5 推送到远程仓库..."

# 检查是否配置了远程仓库
if ! git remote get-url origin &>/dev/null; then
    error "未配置远程仓库。请先添加 origin 远程仓库。"
fi

REMOTE_URL=$(git remote get-url origin)
info "远程仓库: $REMOTE_URL"

# 推送到远程
info "正在推送..."
if git push origin "$CURRENT_BRANCH"; then
    success "✓ 推送成功"
else
    # 如果推送失败，可能需要先拉取
    warn "推送失败，尝试先拉取远程更改..."
    git pull --rebase origin "$CURRENT_BRANCH"
    git push origin "$CURRENT_BRANCH"
fi

# 4. 触发 GitHub Actions
info "4/5 GitHub Actions 将自动构建和部署..."
info "通常需要 2-3 分钟完成部署"

# 5. 完成
echo ""
success "========================================="
success "  ✓ 部署流程已完成！"
success "========================================="
echo ""
info "后续步骤:"
echo "  1. 访问 GitHub Actions 查看构建进度:"
echo "     https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/actions"
echo ""
echo "  2. 构建完成后访问你的网站:"
echo "     https://lllllllama.me"
echo ""
info "提示: 可以使用 'git log --oneline -5' 查看最近的提交"
