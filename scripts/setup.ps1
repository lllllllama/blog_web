Param(
  [Parameter(Mandatory=$false)][string]$TemplateRepoUrl = $env:TEMPLATE_REPO_URL
)

$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "[ERR ] $msg"  -ForegroundColor Red }

try {
  Write-Info "检测 Bundler..."
  $bundlerVersion = (& gem list bundler -i) 2>$null
  if (-not $bundlerVersion) {
    Write-Info "未检测到 Bundler，正在安装..."
    gem install bundler --no-document
  } else {
    Write-Info "Bundler 已安装"
  }

  Write-Info "设置 Bundler 安装目录 vendor/bundle"
  bundle config set path 'vendor/bundle' | Out-Null

  Write-Info "安装依赖（bundle install）"
  bundle install

  # Git 初始化
  if (-not (Test-Path .git)) {
    Write-Info "初始化 Git 仓库"
    git init
    git checkout -b main
  } else {
    # 确保当前分支为 main（非强制）
    try { git symbolic-ref --short -q HEAD | Out-Null } catch {}
  }

  # 可选：拉取模板仓库并合并
  if ($TemplateRepoUrl -and $TemplateRepoUrl.Trim() -ne '') {
    Write-Info "检测到模板仓库：$TemplateRepoUrl"
    $tmp = Join-Path $env:TEMP ("jekyll-template-" + [System.Guid]::NewGuid().ToString())
    git -c http.sslVerify=true clone --depth 1 $TemplateRepoUrl $tmp
    Write-Info "复制模板内容（不覆盖现有同名文件）..."
    $items = Get-ChildItem -Path $tmp -Force -Recurse | Where-Object { $_.FullName -notmatch "\\\.git(\\|$)" }
    foreach ($item in $items) {
      $relative = $item.FullName.Substring($tmp.Length).TrimStart('\\')
      $target = Join-Path (Get-Location) $relative
      if ($item.PSIsContainer) {
        if (-not (Test-Path $target)) { New-Item -ItemType Directory -Path $target | Out-Null }
      } else {
        if (-not (Test-Path $target)) {
          New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
          Copy-Item -Path $item.FullName -Destination $target
        } else {
          Write-Warn "跳过已存在文件：$relative"
        }
      }
    }
    Write-Info "模板复制完成"
  }

  # 首次提交（可选）
  if (-not (git rev-parse --verify HEAD 2>$null)) {
    git add -A
    git commit -m "chore: initial commit (Jekyll + GitHub Pages scaffold)" | Out-Null
    Write-Info "已完成初始提交"
  }

  Write-Host "\n已就绪 ✅ 你可以运行: scripts\serve.ps1 进行本地预览" -ForegroundColor Green
}
catch {
  Write-Err $_.Exception.Message
  exit 1
}

