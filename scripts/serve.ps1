$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Err($msg)  { Write-Host "[ERR ] $msg"  -ForegroundColor Red }

try {
  if (-not (Test-Path Gemfile)) { throw "Gemfile not found. Run this script from the project root." }

  $bindPort = if ($env:JEKYLL_PORT) { [int]$env:JEKYLL_PORT } else { 4000 }
  $bindHost = if ($env:JEKYLL_HOST) { $env:JEKYLL_HOST } else { '127.0.0.1' }
  $url  = "http://{0}:{1}" -f $bindHost, $bindPort

  Write-Info "Starting Jekyll preview server at $url"
  bundle exec ruby -e "load Gem.bin_path('jekyll','jekyll')" -- serve --livereload --host $bindHost --port $bindPort
}
catch {
  Write-Err $_.Exception.Message
  Write-Host "Tip: set JEKYLL_PORT or JEKYLL_HOST if the default address is busy." -ForegroundColor Yellow
  Write-Host "SSL issues on Windows? Try 'ridk install' and update certificates (see README)." -ForegroundColor Yellow
  exit 1
}
