// ===== Dark Mode Toggle =====
(function () {
  const STORAGE_KEY = "theme";
  const DARK = "dark";
  const LIGHT = "light";

  function getPreferredTheme() {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) return stored;
    return window.matchMedia("(prefers-color-scheme: dark)").matches
      ? DARK
      : LIGHT;
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme);
    const btn = document.getElementById("theme-toggle");
    if (btn) {
      btn.textContent = theme === DARK ? "☀️" : "🌙";
    }
  }

  // Apply immediately to avoid flash
  applyTheme(getPreferredTheme());

  document.addEventListener("DOMContentLoaded", function () {
    const btn = document.getElementById("theme-toggle");
    if (btn) {
      btn.addEventListener("click", function () {
        const current = document.documentElement.getAttribute("data-theme");
        const next = current === DARK ? LIGHT : DARK;
        localStorage.setItem(STORAGE_KEY, next);
        applyTheme(next);
      });
    }
  });

  // Listen for system theme changes
  window
    .matchMedia("(prefers-color-scheme: dark)")
    .addEventListener("change", function (e) {
      if (!localStorage.getItem(STORAGE_KEY)) {
        applyTheme(e.matches ? DARK : LIGHT);
      }
    });
})();

// ===== Pangu.js — Auto CJK Spacing =====
document.addEventListener("DOMContentLoaded", function () {
  var script = document.createElement("script");
  script.src =
    "https://cdn.jsdelivr.net/npm/pangu@4.0.7/dist/browser/pangu.min.js";
  script.onload = function () {
    if (window.pangu) {
      pangu.spacingElementByClassName("article-content");
      pangu.spacingElementByClassName("post-summary");
    }
  };
  document.head.appendChild(script);
});
