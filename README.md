# NIF Global Pune — Static Website

Static website for NIF Global Pune (formerly INIFD Pune), a design institute in Pune, India. Originally built on WordPress with Elementor, converted to a pure static HTML/CSS/JS site.

## Running Locally

No build step required. Serve the files with any static file server:

```bash
# Using Python
python3 -m http.server 8000

# Using Node.js
npx serve

# Using PHP
php -S localhost:8000
```

Then open [http://localhost:8000](http://localhost:8000) in your browser.

## Project Structure

```
├── index.html                    # Homepage
├── about-us/                     # About Us page
├── admissions/                   # Admissions page
├── blog-ananya-panday-nif-launch/# Blog post
├── blog-dubai-fashion-week/      # Blog post
├── blog-kala-ghoda-festival/     # Blog post
├── contact-us/                   # Contact page
├── design-management/            # Design Management course page
├── facilities/                   # Facilities page
├── faculty-members/              # Faculty listing page
├── fashion-design/               # Fashion Design course page
├── gallery/                      # Photo gallery page
├── interior-design/              # Interior Design course page
├── privacy-policy/               # Privacy policy page
├── terms-conditions/             # Terms & conditions page
└── assets/
    ├── css/                      # Font CSS files
    ├── plugins/                  # Elementor, JKit, Essential Addons
    ├── themes/                   # Astra theme CSS/JS
    ├── uploads/                  # Images and page-specific CSS
    │   ├── 2026/01/              # January uploads
    │   ├── 2026/02/              # February uploads
    │   └── elementor/            # Elementor-specific CSS and thumbnails
    └── vendor/
        └── wp-core/              # jQuery, jQuery UI, WordPress hooks/i18n
```

## Known Issues

- **Placeholder images**: All images under `assets/uploads/` are 1x1 pixel placeholders. Replace with actual images from the original site or content management system.
- **Forms**: Contact and inquiry forms will not submit (static site). Consider integrating a form service (Formspree, Netlify Forms, etc.).
- **Blog listing**: The `/blogs/blogs.html` page is referenced in navigation but does not exist. Create it or update nav links.
- **Search**: WordPress search functionality (`?s=`) is not available on the static site.

## Tech Stack

- **HTML/CSS/JS** — pure static, no build tools
- **Elementor** — page builder framework (CSS/JS reconstructed)
- **Astra** — WordPress theme (base styles preserved)
- **Swiper v8** — image carousels
- **Tiny Slider** — testimonials carousel
- **jQuery 3.7.1** — DOM manipulation
- **Google Fonts** — Poppins, Inter, Plus Jakarta Sans
