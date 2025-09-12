Param(
  [Parameter(Mandatory=$true)][string]$Title,
  [Parameter(Mandatory=$false)][string]$Slug,
  [Parameter(Mandatory=$false)][string]$Tags = "",
  [Parameter(Mandatory=$false)][string]$Cats = "",
  [Parameter(Mandatory=$false)][string]$Cover = "/assets/img/cover.svg",
  [Parameter(Mandatory=$false)][bool]$Pinned = $false,
  [Parameter(Mandatory=$false)][bool]$Toc = $true,
  [Parameter(Mandatory=$false)][string]$Summary = ""
)

$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Err($msg)  { Write-Host "[ERR ] $msg"  -ForegroundColor Red }

function To-Slug($text) {
  $s = $text -replace "[^\w\u4e00-\u9fa5\- ]", ""  # 保留中文、字母数字、空格和 -
  $s = $s.Trim().ToLower() -replace "\s+", "-"
  return $s
}

try {
  if (-not (Test-Path "_posts")) { New-Item -ItemType Directory -Path "_posts" | Out-Null }

  if (-not $Slug -or $Slug.Trim() -eq '') { $Slug = To-Slug $Title }

  $date = Get-Date -Format "yyyy-MM-dd"
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
  $file = Join-Path "_posts" ("{0}-{1}.md" -f $date, $Slug)

  if (Test-Path $file) { throw "文件已存在：$file" }

  $tagsArr = @()
  if ($Tags -and $Tags.Trim() -ne '') { $tagsArr = $Tags.Split(',') | ForEach-Object { $_.Trim() } }
  $catsArr = @()
  if ($Cats -and $Cats.Trim() -ne '') { $catsArr = $Cats.Split(',') | ForEach-Object { $_.Trim() } }

  $tagsYaml = if ($tagsArr.Count -gt 0) { "[" + ($tagsArr -join ", ") + "]" } else { "[未分类]" }
  $catsYaml = if ($catsArr.Count -gt 0) { "[" + ($catsArr -join ", ") + "]" } else { "[随笔]" }
  $summaryYaml = if ($Summary -and $Summary.Trim() -ne '') { $Summary } else { "这里是文章摘要，可手动编辑或让 Jekyll 自动截断。" }

  $content = @"
---
layout: post
title: $Title
date: $timestamp
categories: $catsYaml
tags: $tagsYaml
pin: $Pinned
cover: $Cover
summary: $summaryYaml
toc: $Toc
---

这里是正文内容。支持 Markdown、代码高亮、图片等。

```bash
echo "Hello"
```
"@

  $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($file, $content, $Utf8NoBom)

  Write-Info "已创建：$file"
}
catch {
  Write-Err $_.Exception.Message
  exit 1
}
