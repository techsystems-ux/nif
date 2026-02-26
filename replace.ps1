$path = "E:\New folder (3)"

Function Replace-PreserveCase {
    param([string]$Text, [string]$Find, [string]$Replace)
    if ([string]::IsNullOrEmpty($Text)) { return $Text }
    
    $Evaluator = [System.Text.RegularExpressions.MatchEvaluator] {
        param($m)
        $orig = $m.Value
        if ($orig -cmatch '^[A-Z]+$') { return $Replace.ToUpper() }
        if ($orig -cmatch '^[A-Z][a-z]*$') {
            return $Replace.Substring(0,1).ToUpper() + $Replace.Substring(1).ToLower()
        }
        if ($orig -cmatch '^[a-z]+$') { return $Replace.ToLower() }
        return $Replace.ToLower()
    }
    
    return [regex]::Replace($Text, [regex]::Escape($Find), $Evaluator, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
}

function Is-Text {
    param($Path)
    $exts = @('.txt', '.html', '.htm', '.css', '.js', '.json', '.php', '.xml', '.svg', '.md', '.csv')
    $ext = [System.IO.Path]::GetExtension($Path).ToLower()
    if ($exts -contains $ext) { return $true }
    
    $bins = @('.png', '.jpg', '.jpeg', '.gif', '.ico', '.pdf', '.zip', '.woff', '.woff2', '.ttf', '.eot', '.mp4', '.webm', '.webp')
    if ($bins -contains $ext) { return $false }

    try {
        $bytes = Get-Content -Path $Path -Encoding Byte -TotalCount 1024 -ErrorAction SilentlyContinue
        if ($bytes -contains 0) { return $false }
        return $true
    } catch {
        return $false
    }
}

# 1. Process contents
Write-Host "Modifying content..."
Get-ChildItem -Path $path -File -Recurse | ForEach-Object {
    if ($_.Name -eq "replace.ps1" -or $_.Name -eq "replace.py" -or $_.FullName -match "\\.gemini\\") { return }
    if (Is-Text $_.FullName) {
        try {
            $content = [System.IO.File]::ReadAllText($_.FullName)
            $newContent = Replace-PreserveCase -Text $content -Find "mumbai" -Replace "pune"
            $newContent = Replace-PreserveCase -Text $newContent -Find "andheri" -Replace "kondhwa"
            
            if ($newContent -cne $content) {
                [System.IO.File]::WriteAllText($_.FullName, $newContent)
                Write-Host "Modified $($_.FullName)"
            }
        } catch {
            Write-Host "Skipped $($_.FullName)"
        }
    }
}

# 2. Rename directories bottom-up
Write-Host "Renaming directories..."
$dirs = Get-ChildItem -Path $path -Directory -Recurse | Sort-Object @{Expression={$_.FullName.Length}; Descending=$true}
foreach ($d in $dirs) {
    if ($d.FullName -match "\\.gemini") { continue }
    $newName = Replace-PreserveCase -Text $d.Name -Find "mumbai" -Replace "pune"
    $newName = Replace-PreserveCase -Text $newName -Find "andheri" -Replace "kondhwa"
    if ($newName -cne $d.Name) {
        Rename-Item -Path $d.FullName -NewName $newName -ErrorAction SilentlyContinue
        Write-Host "Renamed dir $($d.FullName) to $newName"
    }
}

# 3. Rename files
Write-Host "Renaming files..."
$files = Get-ChildItem -Path $path -File -Recurse
foreach ($f in $files) {
    if ($f.FullName -match "\\.gemini") { continue }
    if ($f.Name -eq "replace.ps1" -or $f.Name -eq "replace.py") { continue }
    $newName = Replace-PreserveCase -Text $f.Name -Find "mumbai" -Replace "pune"
    $newName = Replace-PreserveCase -Text $newName -Find "andheri" -Replace "kondhwa"
    if ($newName -cne $f.Name) {
        Rename-Item -Path $f.FullName -NewName $newName -ErrorAction SilentlyContinue
        Write-Host "Renamed file $($f.FullName) to $newName"
    }
}
Write-Host "Replacement Complete"
