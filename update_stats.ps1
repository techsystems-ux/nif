$files = Get-ChildItem -Path "e:\New folder (3)" -Filter *.html -Recurse

$utf8NoBOM = New-Object System.Text.UTF8Encoding($false)
$count = 0

foreach ($file in $files) {
    if ($file.PSIsContainer) { continue }
    
    $content = [IO.File]::ReadAllText($file.FullName, $utf8NoBOM)
    $originalContent = $content
    
    # 1. Update statistics
    $content = $content -replace '23\s*Years of Excellence', '17+ Years of Excellence'
    $content = $content -replace 'data-to-value="25000"', 'data-to-value="25000+"'
    # For Student Placement 100%, it looks like the current text has "Student Placement" inside the h2 and "100" in counter and "%" in suffix.
    # The requirement is likely just to make sure the labels match. Currently, it is "Student Placement" and "100%".
    # And there is a `<h2 class="elementor-heading-title elementor-size-default">23 Years of Excellence with 100% Placement Record</h2>`
    $content = $content -replace '23\s*Years of Excellence with 100% Placement Record', '17+ Years of Excellence with 100% Placement Record'
    
    # 2. Add full stop after "design"
    # The line in question: "empowering them to build meaningful and sustainable careers in design, guided by the academic vision and industry expertise of Ishan Education."
    # Earlier we removed ", guided by the academic vision and industry expertise of Ishan Education."
    # So the line is now "empowering them to build meaningful and sustainable careers in design"
    # We need to add a full stop after "design".
    # Wait, the previous powershell script `update_text.ps1` only removed `,\s*guided by the academic vision and industry expertise of Ishan Education\.`
    # Let's replace the leftover part or just run a specific replace.
    # Current text in index.html (line 4572): "build meaningful and sustainable careers in design"
    $content = $content -replace 'build meaningful and sustainable careers in design(\s*)</p>', 'build meaningful and sustainable careers in design.$1</p>'
    $content = $content -replace 'build meaningful and sustainable careers in design\s*</span>', 'build meaningful and sustainable careers in design.</span>'
    $content = $content -replace 'build meaningful and sustainable careers in design\s*<', 'build meaningful and sustainable careers in design.<'

    if ($content -ne $originalContent) {
        [IO.File]::WriteAllText($file.FullName, $content, $utf8NoBOM)
        Write-Host "Updated $($file.FullName)"
        $count++
    }
}

Write-Host "Total files updated: $count"
