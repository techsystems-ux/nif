$files = Get-ChildItem -Path "e:\New folder (3)" -Filter *.html -Recurse

$pattern = '(?s)<div class="elementor-element elementor-element-4566b9a elementor-widget elementor-widget-heading".+?<div class="elementor-element elementor-element-ffb7977 elementor-widget elementor-widget-heading"[^>]*>.+?<h2 class="elementor-heading-title elementor-size-default">\s*<a href="tel:\+918828002397">.*?Bandra :.*?</a>\s*</h2>\s*</div>'

$replacement = @"
<div class="elementor-element elementor-element-4566b9a elementor-widget elementor-widget-heading" data-id="4566b9a" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
	<h2 class="elementor-heading-title elementor-size-default">
		NIF Global Pune Kondhwa Campus, Rukmini Tower, Guru Nanak Nagar,<br>
		on Narayan Annaji Shinde Road, NIBM , Kondhwa, Pune 411048
	</h2>
</div>
<div class="elementor-element elementor-element-ffb7977 elementor-widget elementor-widget-heading" data-id="ffb7977" data-element_type="widget" data-e-type="widget" data-widget_type="heading.default">
	<h2 class="elementor-heading-title elementor-size-default">
		Contact nos. - <a href="tel:8381006006">8381006006</a> / <a href="tel:9822282817">9822282817</a>
	</h2>
</div>
"@

$utf8NoBOM = New-Object System.Text.UTF8Encoding($false)

$count = 0
foreach ($file in $files) {
    if ($file.PSIsContainer) { continue }
    
    $content = [IO.File]::ReadAllText($file.FullName, $utf8NoBOM)
    if ($content -match $pattern) {
        $content = $content -replace $pattern, $replacement
        [IO.File]::WriteAllText($file.FullName, $content, $utf8NoBOM)
        Write-Host "Updated $($file.FullName)"
        $count++
    }
}

Write-Host "Total files updated: $count"
