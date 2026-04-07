# www's Blog 重构设计文档

## 概述

重构 weivwang.github.io 个人博客。源代码已丢失，需要从零重建 Hugo 博客，自建主题，迁移旧文章，并建立快速发布流程。

## 目标

1. 使用 Hugo 从零搭建博客，自建轻量主题
2. 古典书卷风视觉设计，支持浅色/深色模式切换
3. 纯标签制（无固定分类），灵活组织内容
4. 从旧博客迁移约 18 篇文章
5. GitHub Actions 自动构建部署到 GitHub Pages
6. 提供快速发布脚本，一键将本地 Markdown 发布到博客

## 技术栈

| 组件 | 技术选择 |
|------|---------|
| 静态站点生成器 | Hugo |
| 主题 | 自建主题 `ink`（墨） |
| 托管 | GitHub Pages（gh-pages 分支） |
| CI/CD | GitHub Actions |
| 代码高亮 | Hugo 内置 Chroma |
| 中英文间距 | pangu.js |
| 字体 | Noto Serif CJK SC（衬线） |

## 项目结构

```
blog/
├── config.toml                  # Hugo 全局配置
├── content/
│   ├── posts/                   # 所有博客文章
│   │   ├── react-rethink.md
│   │   └── docker-notes.md
│   └── about.md                 # 关于页面
├── themes/
│   └── ink/                     # 自建主题
│       ├── theme.toml
│       ├── layouts/
│       │   ├── _default/
│       │   │   ├── baseof.html  # 基础模板（全局 HTML 骨架）
│       │   │   ├── list.html    # 默认列表页
│       │   │   ├── single.html  # 默认详情页
│       │   │   └── terms.html   # 标签总览页（所有标签）
│       │   ├── partials/
│       │   │   ├── head.html    # <head> 区域（meta、CSS、字体）
│       │   │   ├── header.html  # 页头导航
│       │   │   └── footer.html  # 页脚
│       │   ├── posts/
│       │   │   ├── list.html    # 文章列表页（首页）
│       │   │   └── single.html  # 文章详情页
│       │   └── page/
│       │       └── single.html  # 独立页面（关于）
│       └── static/
│           ├── css/
│           │   └── style.css    # 全部样式（含深色模式 CSS 变量）
│           └── js/
│               └── main.js      # 主题切换 + pangu.js 初始化
├── static/                      # 全局静态资源（图片等）
├── .github/
│   └── workflows/
│       └── deploy.yml           # GitHub Actions 部署配置
└── scripts/
    └── publish.sh               # 快速发布脚本
```

## 页面设计

### 全局布局

- 单栏居中，最大宽度 700px
- 页头：博客名（www's Blog）+ 座右铭 + 导航栏
- 座右铭：「使其中坦然，不以物伤性，将何适而非快」
- 导航项：首页 · 归档 · 标签 · 关于 · 深色模式切换
- 页脚：版权信息 + Powered by Hugo

### 首页（文章列表）

- 文章按时间倒序排列
- 每篇显示：日期 + 标题 + 摘要（description 或自动截取）+ 标签胶囊
- 支持分页（每页 10 篇）

### 文章详情页

- 标题区：文章标题 + 日期 + 字数 + 预估阅读时间 + 标签
- 正文：行高 2.0，衬线字体排版
- 代码块：圆角暖色底，等宽字体，Chroma 语法高亮
- 引用块：左侧竖线 + 斜体样式
- 底部：上一篇 / 下一篇导航

### 归档页

- 按年份分组
- 每篇显示：日期 + 标题（可点击）

### 标签页

- 标签总览：所有标签以胶囊形式展示，旁标文章数
- 单标签页：该标签下的文章列表

### 关于页

- 独立页面，手动编辑内容

## 视觉设计

### 色彩方案

**浅色模式：**
- 背景：#faf8f5（暖白）
- 正文：#444
- 标题：#333
- 辅助文字：#a09080
- 分割线：#e8e0d8
- 标签背景：#f0ebe4
- 标签文字：#8a7d6b
- 代码块背景：#f5f0ea

**深色模式：**
- 背景：#1c1a17（暖黑）
- 正文：#b0a898
- 标题：#e8e0d8
- 辅助文字：#7a6e60
- 分割线：#3a3530
- 标签背景：#2a2520
- 标签文字：#a09080
- 代码块背景：#252220

### 字体

- 正文/标题：Noto Serif CJK SC（300/400/500 三个字重）
- 代码：SF Mono, Menlo, Consolas, monospace
- 通过 Google Fonts 加载 Noto Serif SC

### 深色模式实现

- CSS 变量定义所有颜色
- `prefers-color-scheme: dark` 跟随系统
- 导航栏提供手动切换按钮（🌙/☀️）
- localStorage 记忆用户选择

## 发布流程

### GitHub Actions 自动部署

触发条件：push 到 `main` 分支

流程：
1. checkout 代码
2. 安装 Hugo（extended 版本）
3. `hugo --minify` 构建
4. 使用 `peaceiris/actions-gh-pages` 部署到 `gh-pages` 分支

### 快速发布脚本 `publish.sh`

用法：
```bash
./scripts/publish.sh ./my-post.md "标签1,标签2"
```

功能：
1. 读取 markdown 文件
2. 检查是否已有 front matter，没有则自动生成：
   - title：从文件名或一级标题提取
   - date：当前时间
   - tags：从命令行参数解析
   - draft：false
3. 复制文件到 `content/posts/`
4. 执行 `git add`、`git commit`、`git push`
5. 输出发布成功信息

## 旧文章迁移

从 weivwang.github.io 抓取现有文章 HTML，转换为 Markdown 格式，补全 front matter（标题、日期、标签），放入 `content/posts/`。

需迁移的文章（约 18 篇）：
- LifeRecord: 写在前面
- StudyNotes: 技术文章收集、腾讯文档&武大前端菁英班笔记、商务智能课堂笔记、CSAPP_AttackLab、React再思考、CSAPP_BombLab、Docker_notes、Embedded_software_courses_notes、JavaEE课堂笔记、Tensorflow八股笔记、Operating_system_experiment、Vue.js学习笔记、Git关联及取消关联远程仓库操作、Js_learning、Cs231n学习笔记
- TechThinking: Business_model_canvas
- ReadPapers: 2021JSA

## 非目标（不做）

- 评论系统
- 搜索功能
- 多语言支持
- RSS 订阅（Hugo 默认自带，不额外定制）
- 图片画廊
- 统计/分析
