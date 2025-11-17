# Makefile for Jekyll Blog
# 快速命令入口

.PHONY: help setup serve build clean deploy new-post

# 默认目标 - 显示帮助
help:
	@echo "Jekyll 博客 - 可用命令:"
	@echo ""
	@echo "  make setup      - 初始化环境（首次使用）"
	@echo "  make serve      - 启动本地预览服务器"
	@echo "  make build      - 构建静态网站"
	@echo "  make clean      - 清理构建文件"
	@echo "  make deploy     - 一键部署到 GitHub Pages"
	@echo "  make new-post   - 创建新文章"
	@echo ""
	@echo "环境变量:"
	@echo "  JEKYLL_PORT=4000  - 设置服务器端口"
	@echo "  JEKYLL_HOST=127.0.0.1  - 设置服务器主机"
	@echo ""

# 初始化环境
setup:
	@if [ -f scripts/setup.sh ]; then \
		./scripts/setup.sh; \
	elif [ -f scripts/setup.ps1 ]; then \
		powershell -ExecutionPolicy Bypass -File scripts/setup.ps1; \
	else \
		echo "未找到设置脚本"; exit 1; \
	fi

# 本地预览
serve:
	@if [ -f scripts/serve.sh ]; then \
		./scripts/serve.sh; \
	elif [ -f scripts/serve.ps1 ]; then \
		powershell -ExecutionPolicy Bypass -File scripts/serve.ps1; \
	else \
		bundle exec jekyll serve --livereload; \
	fi

# 构建网站
build:
	@echo "构建网站..."
	@bundle exec jekyll build
	@echo "✓ 构建完成！输出目录: _site/"

# 清理构建文件
clean:
	@echo "清理构建文件..."
	@bundle exec jekyll clean
	@rm -rf .jekyll-cache .jekyll-metadata
	@echo "✓ 清理完成"

# 一键部署
deploy:
	@if [ -f scripts/deploy.sh ]; then \
		./scripts/deploy.sh; \
	else \
		echo "未找到部署脚本"; exit 1; \
	fi

# 创建新文章
new-post:
	@if [ -f scripts/new-post.sh ]; then \
		./scripts/new-post.sh; \
	elif [ -f scripts/new-post.ps1 ]; then \
		powershell -ExecutionPolicy Bypass -File scripts/new-post.ps1; \
	else \
		echo "未找到创建文章脚本"; exit 1; \
	fi

# 安装依赖（手动）
install:
	@echo "安装 Ruby 依赖..."
	@bundle config set --local path 'vendor/bundle'
	@bundle install --jobs 4 --retry 3
	@echo "✓ 依赖安装完成"

# 更新依赖
update:
	@echo "更新依赖..."
	@bundle update
	@echo "✓ 依赖更新完成"

# 检查配置
check:
	@echo "检查环境配置..."
	@ruby -v
	@bundle -v
	@bundle exec jekyll -v
	@echo ""
	@echo "Git 状态:"
	@git status --short
	@echo ""
	@echo "✓ 检查完成"
