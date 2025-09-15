# 开放投稿（Open Authoring）与审核发布

本仓库已集成 Static CMS（Decap/Netlify CMS 社区版）与 GitHub OAuth 代理，支持任何 GitHub 用户通过后台 `/admin/` 登录并发起投稿（fork + PR），由仓库所有者审核后发布。

## 前置要求
- 仓库需为 Public（公开）。私有仓库会导致外部用户登录后提示 “Repo not found”。
- 分支保护（建议）
  - Require a pull request before merging
  - Require review from Code Owners
  - 可选：Require status checks（选择 Pages 构建）
- CODEOWNERS（本仓库已配置）
  - `_posts/**`、`pages/**`、`admin/**` 由 `@lllllllama` 审核

## 后台登录与投稿流程（外部作者）
1. 访问 `https://<你的域名>/admin/` 用 GitHub 登录
2. 在“文章”集合创建或编辑内容，点击“保存”→“提交以审核”
3. CMS 会自动在投稿者账户 fork 你的公开仓库、创建分支并提交 Pull Request
4. 仓库所有者在 GitHub 审核并合并 PR，随后 GitHub Pages 自动发布

## 附：代理与 OAuth 设置（已就绪）
- OAuth 代理：Render 部署，已在 `admin/config.yml` 的 `backend.base_url` 配置
- 代理允许来源（ORIGINS）：包含 `https://<你的域名>` 与 `https://www.<你的域名>`
- OAuth App 回调：`https://<render域名>/callback`

## 常见问题
- Repo not found：仓库非 Public，或登录账号无权访问私有仓库 → 将仓库公开或添加协作者
- 403/CORS：调整代理的 `ORIGINS` 环境变量，确保包含你的域名（带 https://）
- 回调失败：检查 OAuth App 的 Authorization callback URL 是否为代理的 `/callback`
- 后台空白：强制刷新；本仓库已引入官方 CSS 与正确初始化方式

