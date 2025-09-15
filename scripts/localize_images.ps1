param(
  [Parameter(Mandatory=$true)]
  [string]$PostPath,
  [Parameter(Mandatory=$true)]
  [string]$FolderName
)

if (-not (Test-Path $PostPath)) {
  Write-Error "Post not found: $PostPath"
  exit 1
}

$text = Get-Content -Raw -Path $PostPath
# Replace absolute i-blog URLs to local assets path if any remain
$text = $text -replace 'https://i-blog\.csdnimg\.cn/direct/', "/assets/img/posts/$FolderName/"

# Now wrap local absolute paths with Liquid relative_url for baseurl support
$pattern = "\]\(/assets/img/posts/$([Regex]::Escape($FolderName))/([^\)]+)\)"
$replacement = "]({{ '/assets/img/posts/$FolderName/$1' | relative_url }})"
$text = [Regex]::Replace($text, $pattern, $replacement)

# Fallback: prepend site.baseurl for any remaining markdown images using /assets/
$text = $text -replace "\]\(/assets/", "]( {{ site.baseurl }}/assets/"

# Write back as UTF-8 without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($PostPath, $text, $utf8NoBom)

Write-Host "Updated image links in: $PostPath"
