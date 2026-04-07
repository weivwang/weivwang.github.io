# www's Blog 重构实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 从零重建 www's Blog — Hugo 博客 + 自建 ink 主题 + GitHub Actions 部署 + 快速发布脚本 + 旧文章迁移。

**Architecture:** Hugo 静态站点生成器，自建 `ink` 主题（古典书卷风 + 深色模式），纯标签制无分类。GitHub Actions 监听 main 分支 push，自动构建并部署到 gh-pages 分支。`publish.sh` 脚本实现一键发布本地 Markdown。

**Tech Stack:** Hugo (extended), Noto Serif CJK SC, CSS 变量, pangu.js, GitHub Actions, peaceiris/actions-gh-pages

---

## 文件结构总览

```
blog/
├── config.toml                          # Hugo 全局配置
├── content/
│   ├── posts/                           # 所有博客文章（迁移 + 新增）
│   └── about.md                         # 关于页面
├── themes/ink/
│   ├── theme.toml                       # 主题元信息
│   ├── layouts/
│   │   ├── _default/
│   │   │   ├── baseof.html              # 全局 HTML 骨架
│   │   │   ├── list.html                # 默认列表页
│   │   │   ├── single.html              # 默认详情页
│   │   │   └── terms.html               # 标签总览页
│   │   ├── partials/
│   │   │   ├── head.html                # <head> 区域
│   │   │   ├── header.html              # 页头导航
│   │   │   └── footer.html              # 页脚
│   │   ├── posts/
│   │   │   ├── list.html                # 文章列表页（首页）
│   │   │   └── single.html              # 文章详情页
│   │   └── page/
│   │       └── single.html              # 独立页面（关于）
│   └── static/
│       ├── css/style.css                # 全部样式（含深色模式）
│       └── js/main.js                   # 主题切换 + pangu.js
├── static/                              # 全局静态资源
├── .github/workflows/deploy.yml         # GitHub Actions 部署
├── scripts/publish.sh                   # 快速发布脚本
└── .gitignore
```

---

### Task 1: 初始化 Hugo 项目

**Files:**
- Create: `config.toml`
- Create: `themes/ink/theme.toml`
- Create: `.gitignore`
- Create: `content/posts/.gitkeep`

- [ ] **Step 1: 安装 Hugo**

```bash
brew install hugo
hugo version
```

Expected: 输出 Hugo 版本号，如 `hugo v0.1xx.x+extended ...`

- [ ] **Step 2: 初始化 Hugo 站点**

在 `/Users/wangweiwei/AI/blog` 目录下初始化（目录已存在，用 `--force`）：

```bash
hugo new site . --force
```

Expected: `Congratulations! Your new Hugo site is created in ...`

- [ ] **Step 3: 编写 config.toml**

替换自动生成的 `config.toml`，写入以下内容：

```toml
baseURL = "https://weivwang.github.io/"
languageCode = "zh-cn"
title = "www's Blog"
theme = "ink"

[params]
  subtitle = "使其中坦然，不以物伤性，将何适而非快"
  author = "www"
  description = "www's Blog - 使其中坦然，不以物伤性，将何适而非快"

[taxonomies]
  tag = "tags"

[markup]
  [markup.highlight]
    style = "monokailight"
    lineNos = false
    guessSyntax = true
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true

[menu]
  [[menu.main]]
    name = "首页"
    url = "/"
    weight = 1
  [[menu.main]]
    name = "归档"
    url = "/posts/"
    weight = 2
  [[menu.main]]
    name = "标签"
    url = "/tags/"
    weight = 3
  [[menu.main]]
    name = "关于"
    url = "/about/"
    weight = 4

[pagination]
  pagerSize = 10
```

- [ ] **Step 4: 创建主题元信息**

创建 `themes/ink/theme.toml`：

```toml
name = "ink"
license = "MIT"
licenselink = "https://github.com/weivwang/weivwang.github.io/blob/main/LICENSE"
description = "A minimal Hugo theme with classical Chinese aesthetics"
tags = ["minimal", "blog", "chinese", "dark-mode"]
min_version = "0.100.0"

[author]
  name = "www"
```

- [ ] **Step 5: 创建 .gitignore**

```
public/
resources/
.hugo_build.lock
.DS_Store
.superpowers/
```

- [ ] **Step 6: 创建占位文件并提交**

```bash
mkdir -p content/posts
touch content/posts/.gitkeep
git add config.toml themes/ink/theme.toml .gitignore content/posts/.gitkeep
git commit -m "feat: initialize Hugo site with ink theme config"
```

---

### Task 2: 主题基础模板 — baseof + partials

**Files:**
- Create: `themes/ink/layouts/_default/baseof.html`
- Create: `themes/ink/layouts/partials/head.html`
- Create: `themes/ink/layouts/partials/header.html`
- Create: `themes/ink/layouts/partials/footer.html`

- [ ] **Step 1: 创建 baseof.html — 全局 HTML 骨架**

创建 `themes/ink/layouts/_default/baseof.html`：

```html
<!DOCTYPE html>
<html lang="{{ .Site.LanguageCode }}">
<head>
  {{ partial "head.html" . }}
</head>
<body>
  {{ partial "header.html" . }}
  <main class="container">
    {{ block "main" . }}{{ end }}
  </main>
  {{ partial "footer.html" . }}
  <script src="/js/main.js"></script>
</body>
</html>
```

- [ ] **Step 2: 创建 head.html — head 区域**

创建 `themes/ink/layouts/partials/head.html`：

```html
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} - {{ .Site.Title }}{{ end }}</title>
<meta name="description" content="{{ with .Description }}{{ . }}{{ else }}{{ .Site.Params.description }}{{ end }}">
<link rel="stylesheet" href="/css/style.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@300;400;500&display=swap" rel="stylesheet">
```

- [ ] **Step 3: 创建 header.html — 页头导航**

创建 `themes/ink/layouts/partials/header.html`：

```html
<header class="site-header">
  <div class="container">
    <a href="/" class="site-title">{{ .Site.Title }}</a>
    <p class="site-subtitle">{{ .Site.Params.subtitle }}</p>
    <nav class="site-nav">
      {{ range .Site.Menus.main }}
        <a href="{{ .URL }}" {{ if $.IsMenuCurrent "main" . }}class="active"{{ end }}>{{ .Name }}</a>
        {{ if ne .Name "关于" }}<span class="nav-dot">·</span>{{ end }}
      {{ end }}
      <span class="nav-dot">·</span>
      <button class="theme-toggle" id="theme-toggle" aria-label="切换深色模式">🌙</button>
    </nav>
  </div>
</header>
```

- [ ] **Step 4: 创建 footer.html — 页脚**

创建 `themes/ink/layouts/partials/footer.html`：

```html
<footer class="site-footer">
  <div class="container">
    <p>&copy; {{ now.Year }} {{ .Site.Title }} · Powered by <a href="https://gohugo.io" target="_blank" rel="noopener">Hugo</a></p>
  </div>
</footer>
```

- [ ] **Step 5: 提交**

```bash
git add themes/ink/layouts/
git commit -m "feat: add baseof template and partials (head, header, footer)"
```

---

### Task 3: CSS 样式 — 浅色 + 深色模式

**Files:**
- Create: `themes/ink/static/css/style.css`

- [ ] **Step 1: 创建完整 CSS 文件**

创建 `themes/ink/static/css/style.css`：

```css
/* ===== CSS Variables ===== */
:root {
  --bg: #faf8f5;
  --text: #444;
  --title: #333;
  --subtle: #a09080;
  --border: #e8e0d8;
  --tag-bg: #f0ebe4;
  --tag-text: #8a7d6b;
  --code-bg: #f5f0ea;
  --link: #6b5e50;
  --link-hover: #333;
  --nav-dot: #d0c8c0;
  --blockquote-border: #d0c8c0;
  --blockquote-text: #777;
}

[data-theme="dark"] {
  --bg: #1c1a17;
  --text: #b0a898;
  --title: #e8e0d8;
  --subtle: #7a6e60;
  --border: #3a3530;
  --tag-bg: #2a2520;
  --tag-text: #a09080;
  --code-bg: #252220;
  --link: #c0b0a0;
  --link-hover: #e8e0d8;
  --nav-dot: #3a3530;
  --blockquote-border: #3a3530;
  --blockquote-text: #7a6e60;
}

/* ===== Reset & Base ===== */
*, *::before, *::after {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html {
  font-size: 16px;
  scroll-behavior: smooth;
}

body {
  font-family: "Noto Serif SC", Georgia, "Times New Roman", serif;
  font-weight: 400;
  color: var(--text);
  background-color: var(--bg);
  line-height: 1.8;
  transition: background-color 0.3s ease, color 0.3s ease;
}

a {
  color: var(--link);
  text-decoration: none;
  transition: color 0.2s ease;
}

a:hover {
  color: var(--link-hover);
}

/* ===== Layout ===== */
.container {
  max-width: 700px;
  margin: 0 auto;
  padding: 0 24px;
}

/* ===== Header ===== */
.site-header {
  text-align: center;
  padding: 48px 0 24px;
}

.site-title {
  font-size: 1.625rem;
  color: var(--title);
  letter-spacing: 3px;
  font-weight: 400;
}

.site-title:hover {
  color: var(--title);
}

.site-subtitle {
  font-size: 0.75rem;
  color: var(--subtle);
  margin-top: 10px;
  letter-spacing: 1px;
}

.site-nav {
  margin-top: 16px;
  font-size: 0.8125rem;
}

.site-nav a {
  color: var(--subtle);
  margin: 0 8px;
}

.site-nav a:hover,
.site-nav a.active {
  color: var(--title);
}

.nav-dot {
  color: var(--nav-dot);
}

.theme-toggle {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 0.875rem;
  padding: 0;
  margin-left: 8px;
  vertical-align: middle;
}

/* ===== Divider ===== */
.site-header::after {
  content: "";
  display: block;
  width: calc(100% - 48px);
  max-width: 700px;
  height: 1px;
  background: var(--border);
  margin: 24px auto 0;
}

/* ===== Post List ===== */
.post-list {
  list-style: none;
  padding: 24px 0;
}

.post-item {
  margin-bottom: 28px;
}

.post-date {
  font-size: 0.75rem;
  color: var(--subtle);
}

.post-title {
  font-size: 1.0625rem;
  color: var(--title);
  font-weight: 500;
  margin: 4px 0;
  display: block;
}

.post-title:hover {
  color: var(--link-hover);
}

.post-summary {
  font-size: 0.8125rem;
  color: var(--subtle);
  line-height: 1.7;
}

.post-tags {
  margin-top: 6px;
}

.tag {
  display: inline-block;
  font-size: 0.6875rem;
  background: var(--tag-bg);
  color: var(--tag-text);
  padding: 2px 8px;
  border-radius: 10px;
  margin-right: 4px;
}

.tag:hover {
  color: var(--title);
}

/* ===== Pagination ===== */
.pagination {
  display: flex;
  justify-content: center;
  gap: 16px;
  padding: 16px 0 32px;
  font-size: 0.8125rem;
  color: var(--subtle);
}

.pagination a {
  color: var(--subtle);
}

.pagination a:hover {
  color: var(--title);
}

/* ===== Article ===== */
.article-header {
  margin-bottom: 16px;
}

.article-title {
  font-size: 1.375rem;
  color: var(--title);
  font-weight: 500;
  margin-bottom: 8px;
}

.article-meta {
  font-size: 0.75rem;
  color: var(--subtle);
  margin-bottom: 6px;
}

.article-content {
  padding-top: 16px;
  border-top: 1px solid var(--border);
  font-size: 0.9375rem;
  line-height: 2;
}

.article-content h2 {
  font-size: 1.0625rem;
  color: var(--title);
  font-weight: 500;
  margin: 32px 0 12px;
}

.article-content h3 {
  font-size: 1rem;
  color: var(--title);
  font-weight: 500;
  margin: 24px 0 8px;
}

.article-content p {
  margin-bottom: 12px;
}

.article-content ul,
.article-content ol {
  margin-bottom: 12px;
  padding-left: 24px;
}

.article-content li {
  margin-bottom: 4px;
}

.article-content img {
  max-width: 100%;
  height: auto;
  border-radius: 4px;
  margin: 12px 0;
}

.article-content blockquote {
  border-left: 3px solid var(--blockquote-border);
  margin: 12px 0;
  padding: 8px 16px;
  color: var(--blockquote-text);
  font-style: italic;
}

.article-content pre {
  background: var(--code-bg);
  border-radius: 6px;
  padding: 12px 16px;
  overflow-x: auto;
  margin: 12px 0;
  font-size: 0.8125rem;
  line-height: 1.6;
}

.article-content code {
  font-family: "SF Mono", Menlo, Consolas, monospace;
}

.article-content p code {
  background: var(--code-bg);
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 0.85em;
}

.article-content a {
  text-decoration: underline;
  text-underline-offset: 2px;
}

.article-content table {
  width: 100%;
  border-collapse: collapse;
  margin: 12px 0;
  font-size: 0.875rem;
}

.article-content th,
.article-content td {
  border: 1px solid var(--border);
  padding: 8px 12px;
  text-align: left;
}

.article-content th {
  background: var(--tag-bg);
  color: var(--title);
  font-weight: 500;
}

/* ===== Post Navigation ===== */
.post-nav {
  display: flex;
  justify-content: space-between;
  padding: 24px 0;
  margin-top: 32px;
  border-top: 1px solid var(--border);
  font-size: 0.8125rem;
  color: var(--subtle);
}

.post-nav a {
  color: var(--subtle);
}

.post-nav a:hover {
  color: var(--title);
}

/* ===== Archive ===== */
.archive-year {
  font-size: 1.125rem;
  color: var(--title);
  font-weight: 500;
  margin: 32px 0 12px;
}

.archive-list {
  list-style: none;
}

.archive-item {
  display: flex;
  align-items: baseline;
  gap: 16px;
  margin-bottom: 8px;
  font-size: 0.875rem;
}

.archive-item .post-date {
  flex-shrink: 0;
  width: 60px;
}

/* ===== Tags Page ===== */
.tags-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 24px 0;
}

.tags-cloud .tag {
  font-size: 0.8125rem;
  padding: 4px 12px;
}

/* ===== About Page ===== */
.page-content {
  padding: 24px 0;
  font-size: 0.9375rem;
  line-height: 2;
}

/* ===== Footer ===== */
.site-footer {
  text-align: center;
  padding: 24px 0;
  font-size: 0.6875rem;
  color: var(--subtle);
  border-top: 1px solid var(--border);
  margin-top: 32px;
}

.site-footer a {
  color: var(--subtle);
}

/* ===== Responsive ===== */
@media (max-width: 600px) {
  .site-header {
    padding: 32px 0 16px;
  }
  .site-title {
    font-size: 1.375rem;
  }
  .article-title {
    font-size: 1.1875rem;
  }
  .post-nav {
    flex-direction: column;
    gap: 8px;
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add themes/ink/static/css/style.css
git commit -m "feat: add complete CSS with light/dark mode via CSS variables"
```

---

### Task 4: JavaScript — 深色模式切换 + pangu.js

**Files:**
- Create: `themes/ink/static/js/main.js`

- [ ] **Step 1: 创建 main.js**

创建 `themes/ink/static/js/main.js`：

```javascript
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
```

- [ ] **Step 2: 提交**

```bash
git add themes/ink/static/js/main.js
git commit -m "feat: add dark mode toggle and pangu.js auto CJK spacing"
```

---

### Task 5: 页面模板 — 首页文章列表

**Files:**
- Create: `themes/ink/layouts/posts/list.html`
- Create: `themes/ink/layouts/_default/list.html`

- [ ] **Step 1: 创建文章列表模板**

创建 `themes/ink/layouts/posts/list.html`：

```html
{{ define "main" }}
<ul class="post-list">
  {{ $paginator := .Paginate .Pages }}
  {{ range $paginator.Pages }}
  <li class="post-item">
    <span class="post-date">{{ .Date.Format "2006-01-02" }}</span>
    <a class="post-title" href="{{ .Permalink }}">{{ .Title }}</a>
    {{ if .Description }}
    <p class="post-summary">{{ .Description }}</p>
    {{ else }}
    <p class="post-summary">{{ .Summary | plainify | truncate 120 }}</p>
    {{ end }}
    {{ with .Params.tags }}
    <div class="post-tags">
      {{ range . }}
      <a class="tag" href="{{ "/tags/" | relURL }}{{ . | urlize }}/">{{ . }}</a>
      {{ end }}
    </div>
    {{ end }}
  </li>
  {{ end }}
</ul>
{{ template "_internal/pagination.html" . }}
{{ end }}
```

- [ ] **Step 2: 创建默认列表模板（归档页 — 按年份分组）**

创建 `themes/ink/layouts/_default/list.html`：

```html
{{ define "main" }}
{{ $pages := .Pages }}
{{ range (seq (now.Year) -1 2021) }}
  {{ $year := . }}
  {{ $yearPages := where $pages "Date.Year" $year }}
  {{ if $yearPages }}
  <h2 class="archive-year">{{ $year }}</h2>
  <ul class="archive-list">
    {{ range $yearPages.ByDate.Reverse }}
    <li class="archive-item">
      <span class="post-date">{{ .Date.Format "01-02" }}</span>
      <a class="post-title" href="{{ .Permalink }}">{{ .Title }}</a>
    </li>
    {{ end }}
  </ul>
  {{ end }}
{{ end }}
{{ end }}
```

- [ ] **Step 3: 提交**

```bash
git add themes/ink/layouts/posts/list.html themes/ink/layouts/_default/list.html
git commit -m "feat: add post list templates with pagination and tags"
```

---

### Task 6: 页面模板 — 文章详情页

**Files:**
- Create: `themes/ink/layouts/posts/single.html`
- Create: `themes/ink/layouts/_default/single.html`

- [ ] **Step 1: 创建文章详情页模板**

创建 `themes/ink/layouts/posts/single.html`：

```html
{{ define "main" }}
<article>
  <div class="article-header">
    <h1 class="article-title">{{ .Title }}</h1>
    <div class="article-meta">
      {{ .Date.Format "2006-01-02" }} · 约 {{ .WordCount }} 字 · 阅读约 {{ .ReadingTime }} 分钟
    </div>
    {{ with .Params.tags }}
    <div class="post-tags">
      {{ range . }}
      <a class="tag" href="{{ "/tags/" | relURL }}{{ . | urlize }}/">{{ . }}</a>
      {{ end }}
    </div>
    {{ end }}
  </div>
  <div class="article-content">
    {{ .Content }}
  </div>
  <nav class="post-nav">
    <span>
      {{ with .PrevInSection }}
      <a href="{{ .Permalink }}">← {{ .Title }}</a>
      {{ end }}
    </span>
    <span>
      {{ with .NextInSection }}
      <a href="{{ .Permalink }}">{{ .Title }} →</a>
      {{ end }}
    </span>
  </nav>
</article>
{{ end }}
```

- [ ] **Step 2: 创建默认详情页模板（关于页等）**

创建 `themes/ink/layouts/_default/single.html`：

```html
{{ define "main" }}
<article>
  <h1 class="article-title">{{ .Title }}</h1>
  <div class="page-content article-content">
    {{ .Content }}
  </div>
</article>
{{ end }}
```

- [ ] **Step 3: 提交**

```bash
git add themes/ink/layouts/posts/single.html themes/ink/layouts/_default/single.html
git commit -m "feat: add article detail and default single page templates"
```

---

### Task 7: 页面模板 — 标签页 + 归档页

**Files:**
- Create: `themes/ink/layouts/_default/terms.html`

- [ ] **Step 1: 创建标签总览页模板**

创建 `themes/ink/layouts/_default/terms.html`：

```html
{{ define "main" }}
<h2 class="article-title">标签</h2>
<div class="tags-cloud">
  {{ range .Data.Terms.Alphabetical }}
  <a class="tag" href="{{ .Page.Permalink }}">{{ .Page.Title }} ({{ .Count }})</a>
  {{ end }}
</div>
{{ end }}
```

- [ ] **Step 2: 提交**

```bash
git add themes/ink/layouts/_default/terms.html
git commit -m "feat: add tags overview and archive page templates"
```

---

### Task 8: 测试页面 + 本地预览

**Files:**
- Create: `content/about.md`
- Create: `content/posts/hello-world.md`

- [ ] **Step 1: 创建测试文章**

创建 `content/posts/hello-world.md`：

```markdown
---
title: "Hello World"
date: 2026-04-07
tags: ["测试", "Hugo"]
description: "博客重建后的第一篇测试文章"
---

## 这是一个测试

这是博客重建后的第一篇文章，用于测试主题的各项功能。

### 代码块测试

```javascript
function hello() {
  console.log("Hello, World!");
}
```

### 引用测试

> 使其中坦然，不以物伤性，将何适而非快。

### 列表测试

- 这是第一项
- 这是第二项
- 这是第三项

### 行内代码测试

这是一个 `inline code` 测试，以及中英文mixing的pangu.js效果测试。
```

- [ ] **Step 2: 创建关于页面**

创建 `content/about.md`：

```markdown
---
title: "关于"
layout: "single"
---

这是 www 的个人博客，记录技术、生活与随想。

座右铭：使其中坦然，不以物伤性，将何适而非快。
```

- [ ] **Step 3: 本地预览验证**

```bash
hugo server -D
```

Expected: 输出 `Web Server is available at http://localhost:1313/`

打开浏览器验证以下页面：
- `http://localhost:1313/` — 首页文章列表
- `http://localhost:1313/posts/hello-world/` — 文章详情
- `http://localhost:1313/tags/` — 标签页
- `http://localhost:1313/about/` — 关于页
- 点击 🌙 按钮测试深色模式切换

- [ ] **Step 4: 提交**

```bash
git add content/
git commit -m "feat: add test post and about page for local preview"
```

---

### Task 9: GitHub Actions 自动部署

**Files:**
- Create: `.github/workflows/deploy.yml`

- [ ] **Step 1: 创建部署 workflow**

创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy Hugo site to GitHub Pages

on:
  push:
    branches:
      - main

permissions:
  contents: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    concurrency:
      group: ${{ github.workflow }}-${{ github.ref }}
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: true
          fetch-depth: 0

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: "latest"
          extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

- [ ] **Step 2: 提交**

```bash
git add .github/workflows/deploy.yml
git commit -m "feat: add GitHub Actions workflow for auto deployment"
```

---

### Task 10: 快速发布脚本

**Files:**
- Create: `scripts/publish.sh`

- [ ] **Step 1: 创建 publish.sh**

创建 `scripts/publish.sh`：

```bash
#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/publish.sh <markdown-file> [tags]
# Example: ./scripts/publish.sh ~/notes/my-post.md "前端,React"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <markdown-file> [tags]"
  echo "Example: $0 ./my-post.md \"前端,React\""
  exit 1
fi

SOURCE_FILE="$1"
TAGS="${2:-}"

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: File '$SOURCE_FILE' not found."
  exit 1
fi

# Get the blog root directory (script is in blog/scripts/)
BLOG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
POSTS_DIR="$BLOG_DIR/content/posts"

# Extract filename without extension for slug
FILENAME=$(basename "$SOURCE_FILE")
SLUG="${FILENAME%.*}"
# Sanitize slug: lowercase, replace spaces/underscores with hyphens
SLUG=$(echo "$SLUG" | tr '[:upper:]' '[:lower:]' | sed 's/[_ ]/-/g')

DEST_FILE="$POSTS_DIR/$SLUG.md"

# Check if file already has front matter (starts with ---)
HAS_FRONTMATTER=false
FIRST_LINE=$(head -n 1 "$SOURCE_FILE")
if [ "$FIRST_LINE" = "---" ]; then
  HAS_FRONTMATTER=true
fi

if [ "$HAS_FRONTMATTER" = true ]; then
  # Copy as-is
  cp "$SOURCE_FILE" "$DEST_FILE"
  echo "Copied with existing front matter."
else
  # Try to extract title from first H1
  TITLE=$(grep -m 1 '^# ' "$SOURCE_FILE" | sed 's/^# //' || echo "$SLUG")
  if [ -z "$TITLE" ]; then
    TITLE="$SLUG"
  fi
  DATE=$(date +"%Y-%m-%dT%H:%M:%S%z")

  # Build tags array
  TAGS_YAML=""
  if [ -n "$TAGS" ]; then
    TAGS_YAML="tags: ["
    IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
    for i in "${!TAG_ARRAY[@]}"; do
      TAG=$(echo "${TAG_ARRAY[$i]}" | xargs)  # trim whitespace
      if [ $i -gt 0 ]; then
        TAGS_YAML+=", "
      fi
      TAGS_YAML+="\"$TAG\""
    done
    TAGS_YAML+="]"
  fi

  # Write front matter + content
  {
    echo "---"
    echo "title: \"$TITLE\""
    echo "date: $DATE"
    echo "draft: false"
    if [ -n "$TAGS_YAML" ]; then
      echo "$TAGS_YAML"
    fi
    echo "---"
    echo ""
    # Skip the first H1 line if we used it as title
    if grep -q '^# ' "$SOURCE_FILE"; then
      sed '0,/^# /{/^# /d;}' "$SOURCE_FILE"
    else
      cat "$SOURCE_FILE"
    fi
  } > "$DEST_FILE"
  echo "Generated front matter for: $TITLE"
fi

echo "Published to: $DEST_FILE"

# Git operations
cd "$BLOG_DIR"
git add "$DEST_FILE"
git commit -m "publish: $SLUG"
git push

echo ""
echo "✓ Published and pushed! GitHub Actions will deploy shortly."
echo "  URL: https://weivwang.github.io/posts/$SLUG/"
```

- [ ] **Step 2: 设置可执行权限**

```bash
chmod +x scripts/publish.sh
```

- [ ] **Step 3: 提交**

```bash
git add scripts/publish.sh
git commit -m "feat: add publish.sh script for one-command blog publishing"
```

---

### Task 11: 迁移旧博客文章

**Files:**
- Create: `content/posts/` 下约 18 个 markdown 文件

- [ ] **Step 1: 从旧博客抓取文章列表**

使用以下脚本从 weivwang.github.io 抓取所有文章内容。对于每篇文章：

1. 抓取 HTML 页面
2. 提取正文内容，转换为 Markdown
3. 补全 front matter（title、date、tags）
4. 保存到 `content/posts/`

需要迁移的文章清单：

| 原分类 | 文章 | 目标文件名 | 建议标签 |
|--------|------|-----------|---------|
| LifeRecord | 写在前面 | xie-zai-qian-mian.md | 随笔 |
| StudyNotes | 技术文章收集 | tech-articles-collection.md | 收藏 |
| StudyNotes | 腾讯文档&武大前端菁英班笔记 | tencent-frontend-notes.md | 前端 |
| StudyNotes | 商务智能课堂笔记 | business-intelligence-notes.md | 课程笔记 |
| StudyNotes | CSAPP_AttackLab | csapp-attacklab.md | CS, CSAPP |
| StudyNotes | React再思考 | react-rethink.md | 前端, React |
| StudyNotes | CSAPP_BombLab | csapp-bomblab.md | CS, CSAPP |
| StudyNotes | Docker_notes | docker-notes.md | DevOps, Docker |
| StudyNotes | Embedded_software_courses_notes | embedded-software-notes.md | 嵌入式 |
| StudyNotes | JavaEE课堂笔记 | javaee-notes.md | Java, 课程笔记 |
| StudyNotes | Tensorflow八股笔记 | tensorflow-notes.md | ML, TensorFlow |
| StudyNotes | Operating_system_experiment | os-experiment.md | CS, 操作系统 |
| StudyNotes | Vue.js学习笔记 | vue-learning.md | 前端, Vue |
| StudyNotes | Git关联及取消关联远程仓库操作 | git-remote-ops.md | Git |
| StudyNotes | Js_learning | js-learning.md | 前端, JavaScript |
| StudyNotes | Cs231n学习笔记 | cs231n-notes.md | ML, CS231n |
| TechThinking | Business_model_canvas | business-model-canvas.md | 商业 |
| ReadPapers | 2021JSA | 2021-jsa-paper.md | 论文 |

对每篇文章，抓取对应 URL 的 HTML 正文，转换为 Markdown，写入 `content/posts/` 下对应文件。

由于文章较多，使用一个 agent 进行批量抓取和转换，逐篇创建 markdown 文件。

- [ ] **Step 2: 验证迁移结果**

```bash
hugo server -D
```

浏览 `http://localhost:1313/` 确认所有迁移文章正确显示。

- [ ] **Step 3: 删除测试文章，提交迁移结果**

```bash
rm content/posts/hello-world.md
git add content/posts/
git commit -m "feat: migrate 18 articles from old blog"
```

---

### Task 12: 首页路由配置

**Files:**
- Modify: `config.toml`

- [ ] **Step 1: 配置首页显示文章列表**

在 `config.toml` 末尾添加首页使用 posts section 的配置。如果首页没有正确显示文章列表，创建 `themes/ink/layouts/index.html`：

```html
{{ define "main" }}
<ul class="post-list">
  {{ $paginator := .Paginate (where .Site.RegularPages "Section" "posts") }}
  {{ range $paginator.Pages }}
  <li class="post-item">
    <span class="post-date">{{ .Date.Format "2006-01-02" }}</span>
    <a class="post-title" href="{{ .Permalink }}">{{ .Title }}</a>
    {{ if .Description }}
    <p class="post-summary">{{ .Description }}</p>
    {{ else }}
    <p class="post-summary">{{ .Summary | plainify | truncate 120 }}</p>
    {{ end }}
    {{ with .Params.tags }}
    <div class="post-tags">
      {{ range . }}
      <a class="tag" href="{{ "/tags/" | relURL }}{{ . | urlize }}/">{{ . }}</a>
      {{ end }}
    </div>
    {{ end }}
  </li>
  {{ end }}
</ul>
{{ template "_internal/pagination.html" . }}
{{ end }}
```

- [ ] **Step 2: 提交**

```bash
git add themes/ink/layouts/index.html
git commit -m "feat: add homepage template showing posts list"
```

---

### Task 13: 最终验证 + 推送部署

- [ ] **Step 1: 完整本地验证**

```bash
hugo server
```

逐一验证：
- 首页：文章列表正确、分页工作、标签显示
- 文章详情：排版正确、代码高亮、上下篇导航
- 标签页：标签显示正确、点击跳转
- 关于页：内容正确
- 深色模式：所有页面切换正常
- 移动端：窗口缩小验证响应式

- [ ] **Step 2: 构建检查**

```bash
hugo --minify
ls -la public/
```

Expected: `public/` 目录下有完整的 HTML 文件

- [ ] **Step 3: 连接远程仓库并推送**

```bash
git branch -m master main
git remote add origin git@github.com:weivwang/weivwang.github.io.git
git push -u origin main
```

推送后 GitHub Actions 会自动构建并部署到 gh-pages 分支。

- [ ] **Step 4: 验证线上部署**

等待 GitHub Actions 完成（约 1-2 分钟），访问 https://weivwang.github.io 确认：
- 页面正常加载
- 文章内容完整
- 深色模式工作
- 标签导航正常

- [ ] **Step 5: 测试发布脚本**

创建一个测试文章验证发布流程：

```bash
echo "# 发布测试\n\n这是一篇通过 publish.sh 发布的测试文章。" > /tmp/test-publish.md
./scripts/publish.sh /tmp/test-publish.md "测试"
```

Expected: 自动提交并推送，GitHub Actions 触发部署。

确认后删除测试文章：

```bash
rm content/posts/test-publish.md
git add -A && git commit -m "chore: remove test publish article" && git push
```
