/*! JKit Testimonials - tiny-slider Initialization for Static Sites */
!function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {
    initJkitTestimonials();
  });

  function initJkitTestimonials() {
    if (typeof tns !== "function") {
      console.warn("[JKit Testimonials] tiny-slider (tns) is not loaded.");
      return;
    }

    /* Find all testimonial containers */
    var containers = document.querySelectorAll(
      ".jkit-testimonials .tns-ovh, " +
      ".jkit-testimonials-wrapper, " +
      ".jkit-testimonials .testimonials-track"
    );

    /* If the specific inner wrappers aren't found, try the top-level widget */
    if (!containers.length) {
      containers = document.querySelectorAll(".jkit-testimonials");
    }

    containers.forEach(function (container) {
      /* Skip if tiny-slider has already initialised on this node */
      if (container.classList.contains("tns-slider")) return;

      /* Look for a slide wrapper inside */
      var slideContainer = container.querySelector(".tns-ovh .tns-inner > div") ||
                           container.querySelector(".tns-inner > div") ||
                           container.querySelector(".testimonials-track") ||
                           container;

      /* Read data attributes or data-settings for config */
      var settings = {};
      try {
        var raw = container.getAttribute("data-settings") ||
                  (container.closest("[data-settings]") || {}).getAttribute &&
                  container.closest("[data-settings]").getAttribute("data-settings");
        if (raw) settings = JSON.parse(raw);
      } catch (e) {}

      var itemsDesktop = parseInt(settings.sg_testimonials_slide_show_item, 10) ||
                         parseInt(settings.items, 10) || 3;
      var itemsTablet  = parseInt(settings.sg_testimonials_slide_show_item_tablet, 10) ||
                         parseInt(settings.items_tablet, 10) || 2;
      var itemsMobile  = parseInt(settings.sg_testimonials_slide_show_item_mobile, 10) ||
                         parseInt(settings.items_mobile, 10) || 1;
      var autoplay     = settings.sg_testimonials_autoplay !== false &&
                         settings.sg_testimonials_autoplay !== "no";
      var autoplayTime = parseInt(settings.sg_testimonials_autoplay_timeout, 10) || 4000;
      var showNav      = settings.sg_testimonials_show_navigation !== false &&
                         settings.sg_testimonials_show_navigation !== "no";
      var showDots     = settings.sg_testimonials_show_dots !== false;
      var loop         = settings.sg_testimonials_loop !== false;
      var speed        = parseInt(settings.sg_testimonials_slide_speed, 10) || 400;
      var gutter       = parseInt(settings.sg_testimonials_margin, 10) || 10;

      var tnsConfig = {
        container: slideContainer,
        items: itemsDesktop,
        slideBy: 1,
        autoplay: autoplay,
        autoplayTimeout: autoplayTime,
        autoplayButtonOutput: false,
        controls: showNav,
        nav: showDots,
        loop: loop,
        speed: speed,
        gutter: gutter,
        mouseDrag: true,
        swipeAngle: false,
        responsive: {
          0: {
            items: itemsMobile,
            gutter: Math.min(gutter, 10)
          },
          768: {
            items: itemsTablet,
            gutter: gutter
          },
          1025: {
            items: itemsDesktop,
            gutter: gutter
          }
        }
      };

      /* Look for custom nav/dots containers */
      var widget = container.closest(".elementor-widget") || container.closest(".jkit-testimonials");
      if (widget) {
        var navPrev = widget.querySelector(".tns-controls [data-controls='prev'], .jkit-nav-prev");
        var navNext = widget.querySelector(".tns-controls [data-controls='next'], .jkit-nav-next");
        if (navPrev && navNext) {
          tnsConfig.controlsContainer = navPrev.parentElement;
        }
        var dotsContainer = widget.querySelector(".tns-nav, .jkit-nav-dots");
        if (dotsContainer) {
          tnsConfig.navContainer = dotsContainer;
        }
      }

      try {
        tns(tnsConfig);
      } catch (e) {
        console.warn("[JKit Testimonials] tns init failed:", e);
      }
    });
  }

}();
