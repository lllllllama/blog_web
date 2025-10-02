Param(
  [Parameter(Mandatory=$false)][string]$TemplateRepoUrl = $env:TEMPLATE_REPO_URL
)

$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "[ERR ] $msg"  -ForegroundColor Red }

try {
  Write-Info "Checking Bundler..."
  $bundlerInstalled = (& gem list bundler -i) 2>$null
  if (-not $bundlerInstalled) {
    Write-Info "Bundler not found, installing..."
    gem install bundler --no-document
  } else {
    Write-Info "Bundler already installed."
  }

  Write-Info "Configuring bundle install path (vendor/bundle)"
  bundle config set path 'vendor/bundle' | Out-Null

  Write-Info "Installing Ruby dependencies (bundle install)"
  bundle install

  if (-not (Test-Path .git)) {
    Write-Info "Initializing git repository"
    git init
    git checkout -b main
  } else {
    try { git symbolic-ref --short -q HEAD | Out-Null } catch {}
  }

  if ($TemplateRepoUrl -and $TemplateRepoUrl.Trim() -ne '') {
    Write-Info "Template repository detected -> $TemplateRepoUrl"
    $tmp = Join-Path $env:TEMP ("jekyll-template-" + [System.Guid]::NewGuid().ToString())
    git -c http.sslVerify=true clone --depth 1 $TemplateRepoUrl $tmp
    Write-Info "Copying template contents (skip existing files)..."
    $items = Get-ChildItem -Path $tmp -Force -Recurse | Where-Object { $_.FullName -notmatch "\\\.git(\\|$)" }
    foreach ($item in $items) {
      $relative = $item.FullName.Substring($tmp.Length).TrimStart('\')
      $target = Join-Path (Get-Location) $relative
      if ($item.PSIsContainer) {
        if (-not (Test-Path $target)) { New-Item -ItemType Directory -Path $target | Out-Null }
      } else {
        if (-not (Test-Path $target)) {
          New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
          Copy-Item -Path $item.FullName -Destination $target
        } else {
          Write-Warn "Skip existing file: $relative"
        }
      }
    }
    Write-Info "Template copy completed."
  }

  if (-not (git rev-parse --verify HEAD 2>$null)) {
    git add -A
    git commit -m "chore: initial commit (Jekyll + GitHub Pages scaffold)" | Out-Null
    Write-Info "Initial commit created."
  }

  Write-Host "`nReady! You can now run scripts\serve.ps1 for local preview." -ForegroundColor Green
}
catch {
  Write-Err $_.Exception.Message
  exit 1
}