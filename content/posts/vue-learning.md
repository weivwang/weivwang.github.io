---
title: "Vue.js学习笔记"
date: 2021-04-30
tags: ["前端", "Vue"]
draft: false
---

## 引入 Vue

两种 CDN 方式：开发版本（带调试功能）和生产优化版本。

## Vue 指令

### v-text

替换元素文本内容，类似于 mustache 语法，但会覆盖所有内部文本。

### v-html

通过设置 `innerHTML` 渲染 HTML 内容，用于从数据属性中显示格式化标记。

### v-on

为 DOM 元素附加事件监听器。语法 `v-on:click="method"` 可以缩写为 `@click="method"`。

### v-show

使用 CSS `display` 属性控制元素可见性。元素保留在 DOM 中，但在条件为 false 时隐藏。

### v-if

通过在条件变化时从 DOM 树中完全添加/移除元素来条件性渲染。

## 性能考虑

- **频繁切换用 `v-show`**（切换成本低）
- **不频繁切换用 `v-if`**（操作 DOM 结构更彻底）
