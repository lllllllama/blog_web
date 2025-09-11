Param(
  [Parameter(Mandatory=$true)][string]$Repo
)

$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Err($msg)  { Write-Host "[ERR ] $msg"  -ForegroundColor Red }

try {
  if (-not (Test-Path .git)) { throw "未检测到 .git，请先运行 scripts\setup.ps1" }
  if (-not $Repo.StartsWith("http") -and -not $Repo.Contains(":")) {
    throw "无效的仓库地址（示例：https://github.com/<username>/<repo>.git 或 git@github.com:<username>/<repo>.git）"
  }

  Write-Info "设置远端 origin => $Repo"
  if ((git remote) -match '^origin$') {
    git remote set-url origin $Repo
  } else {
    git remote add origin $Repo
  }

  Write-Info "首次推送 main 分支"
  git add -A
  git commit -m "chore: first push" 2>$null | Out-Null
  git push -u origin main

  Write-Host "\n已推送到：$Repo" -ForegroundColor Green
  Write-Host "下一步：" -ForegroundColor Green
  Write-Host "1) 打开仓库 Settings -> Pages -> 选择 'GitHub Actions' 部署源（本项目已包含 pages.yml）。" -ForegroundColor Yellow
  Write-Host "2) 首次部署后，查看 Actions 日志与 Pages 部署状态。" -ForegroundColor Yellow
  Write-Host "3) 如果使用自定义域名，请在仓库根目录写入 CNAME 并配置 DNS。" -ForegroundColor Yellow
}
catch {
  Write-Err $_.Exception.Message
  exit 1
}

