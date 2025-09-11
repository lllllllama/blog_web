Param(
  [Parameter(Mandatory=$true)][string]$Title,
  [Parameter(Mandatory=$false)][string]$Slug
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

  $content = @"
---
layout: post
title: $Title
date: $timestamp
categories: [随笔]
tags: [未分类]
pin: false
excerpt: 这里是文章摘要，可手动编辑或让 Jekyll 自动截断。
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

