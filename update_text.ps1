$files = Get-ChildItem -Path "e:\New folder (3)" -Filter *.html -Recurse

$utf8NoBOM = New-Object System.Text.UTF8Encoding($false)
$count = 0

foreach ($file in $files) {
    if ($file.PSIsContainer) { continue }
    
    $content = [IO.File]::ReadAllText($file.FullName, $utf8NoBOM)
    $originalContent = $content
    
    # Replace nifd with NIF case insensitively
    $content = $content -ireplace '\bnifd\b', 'NIF'
    
    # Remove the specific line
    $content = $content -replace ',\s*guided by the academic vision and industry expertise of Ishan Education\.', ''
    
    if ($content -ne $originalContent) {
        [IO.File]::WriteAllText($file.FullName, $content, $utf8NoBOM)
        Write-Host "Updated $($file.FullName)"
        $count++
    }
}

Write-Host "Total files updated: $count"
