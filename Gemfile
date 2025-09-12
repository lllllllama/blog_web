source "https://rubygems.org"

# A 模式：使用 GitHub Pages 受支持版本集合（推荐，默认）
# 在此模式下，请尽量只使用 GitHub Pages 官方支持的插件集合：
# https://pages.github.com/versions/
gem "github-pages", group: :jekyll_plugins

# 代码高亮（Rouge 已被 Jekyll 默认使用，这里显式声明以便本地一致）
gem "rouge"

# 在 Ruby >= 3 的本地环境中，Jekyll 3.x 需要 webrick 作为开发服务器
group :development do
  gem "webrick", "~> 1.8"
end

# B 模式（自行构建）切换说明：
# 如果需要使用 GitHub Pages 未支持的插件，请改用 B 模式：
# 1) 注释或移除上面的 `gem "github-pages"` 行
# 2) 添加：
#      gem "jekyll", "~> 4.3"
#      gem "jekyll-feed"
#      gem "jekyll-seo-tag"
#      gem "jekyll-sitemap"
#      gem "jekyll-paginate"
#      # 如需目录生成、归档增强，可使用：
#      # gem "jekyll-toc"    # 注意：不在 GitHub Pages 白名单，需 B 模式
#      # gem "jekyll-archives" # 注意：不在 GitHub Pages 白名单，需 B 模式
#      gem "rouge"
#      group :development do
#        gem "webrick", "~> 1.8"
#      end
# 3) 改用工作流 pages.yml 的 B 模式（见 README），由 Actions 编译并发布 `_site`。
