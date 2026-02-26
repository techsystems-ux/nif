$indexPath = "e:\New folder (3)\index.html"
$utf8NoBOM = New-Object System.Text.UTF8Encoding($false)

# 1. Inject Gallery CSS
$indexContent = [IO.File]::ReadAllText($indexPath, $utf8NoBOM)

$cssBlock = @"
<style id="custom-gallery-fix">
  .elementor-element-3585636e .elementor-main-swiper { display: block !important; }
  .elementor-element-3585636e .swiper-wrapper {
    display: grid !important;
    grid-template-columns: repeat(3, 1fr) !important;
    gap: 15px !important;
    transform: none !important;
    width: 100% !important;
  }
  .elementor-element-3585636e .swiper-slide {
    width: 100% !important;
    margin: 0 !important;
    aspect-ratio: 1 / 1 !important;
    overflow: hidden !important;
    border-radius: 8px !important;
  }
  .elementor-element-3585636e .elementor-carousel-image {
    width: 100% !important;
    height: 100% !important;
    background-size: cover !important;
    background-position: center !important;
  }
  .elementor-element-3585636e .elementor-swiper-button { display: none !important; }
  @media (max-width: 767px) {
    .elementor-element-3585636e .swiper-wrapper { grid-template-columns: repeat(1, 1fr) !important; }
  }
</style>
</head>
"@

if ($indexContent -notmatch 'id="custom-gallery-fix"') {
    $indexContent = $indexContent -replace '(?i)</head>', $cssBlock
    [IO.File]::WriteAllText($indexPath, $indexContent, $utf8NoBOM)
    Write-Host "Injected Gallery fix into index.html"
}


# 2. Inject Animation Fallback
$animationScript = @"
<script id="custom-animation-fallback">
document.addEventListener("DOMContentLoaded", function() {
    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const element = entry.target;
                const settingsStr = element.getAttribute('data-settings');
                let animation = 'fadeInUp';
                let animationDelay = 0;
                if (settingsStr) {
                    try {
                        const settings = JSON.parse(settingsStr);
                        if (settings._animation || settings.animation) {
                            animation = settings._animation || settings.animation;
                        }
                        if (settings.animation_delay) {
                            animationDelay = parseInt(settings.animation_delay, 10);
                        }
                    } catch (e) {}
                }
                
                setTimeout(() => {
                    element.classList.remove('elementor-invisible');
                    element.classList.add('animated', animation);
                }, animationDelay);
                
                observer.unobserve(element);
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.elementor-invisible').forEach(el => {
        observer.observe(el);
    });
});
</script>
</body>
"@

$files = Get-ChildItem -Path "e:\New folder (3)" -Filter *.html -Recurse
$count = 0

foreach ($file in $files) {
    if ($file.PSIsContainer) { continue }
    
    $content = [IO.File]::ReadAllText($file.FullName, $utf8NoBOM)
    
    if ($content -notmatch 'id="custom-animation-fallback"') {
        $content = $content -replace '</body>', $animationScript
        [IO.File]::WriteAllText($file.FullName, $content, $utf8NoBOM)
        $count++
    }
}

Write-Host "Injected Animation Fallbacks into $count HTML files."
