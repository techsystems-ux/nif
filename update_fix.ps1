$file = "e:\New folder (3)\index.html"
$utf8NoBOM = New-Object System.Text.UTF8Encoding($false)

$content = [IO.File]::ReadAllText($file, $utf8NoBOM)
$originalContent = $content

$pattern = '(?s)build meaningful and sustainable careers in design, guided\s*by the academic vision and industry expertise of\s*<strong>Ishan Education</strong>\.'
$replacement = 'build meaningful and sustainable careers in design.'

$content = $content -replace $pattern, $replacement

if ($content -ne $originalContent) {
    [IO.File]::WriteAllText($file, $content, $utf8NoBOM)
    Write-Host "Updated $($file)"
} else {
    Write-Host "No changes"
}
