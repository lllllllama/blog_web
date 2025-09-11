$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Err($msg)  { Write-Host "[ERR ] $msg"  -ForegroundColor Red }

try {
  if (-not (Test-Path Gemfile)) { throw "未找到 Gemfile，请在项目根目录运行。" }

  # 常见问题提示：Windows 端口占用
  $port = 4000
  $host = '127.0.0.1'
  if ($env:JEKYLL_PORT) { $port = [int]$env:JEKYLL_PORT }
  if ($env:JEKYLL_HOST) { $host = $env:JEKYLL_HOST }

  Write-Info "启动 Jekyll 预览服务 (http://$host:$port)"
  bundle exec jekyll serve --livereload --host $host --port $port
}
catch {
  Write-Err $_.Exception.Message
  Write-Host "如果遇到端口占用，请设置环境变量 JEKYLL_PORT 或修改脚本中的端口。" -ForegroundColor Yellow
  Write-Host "Ruby SSL/证书问题可尝试：ridk install 并更新证书，详见 README。" -ForegroundColor Yellow
  exit 1
}

