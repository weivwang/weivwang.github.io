---
title: "JavaScript学习笔记"
date: 2021-04-28
tags: ["前端", "JavaScript"]
draft: false
---

## DOM（2021-1-31）

### DOM 简介

文档对象模型（DOM）是"W3C制定的处理HTML或XML的标准编程接口"，使得通过编程接口修改网页内容和样式成为可能。

关键概念：
- **Document**：代表页面
- **Element**：代表标签
- **Node**：包含所有内容（属性、标签、文本、注释）

### 获取元素

常用方法：
- `document.getElementById(id)` — 按ID选择
- `document.getElementsByTagName()` — 按标签名
- `document.querySelector()` — CSS选择器
- `document.body` — 直接访问

### 事件

事件由三部分组成：事件源、事件类型和事件处理程序。

```javascript
var btn = document.getElementById('btn');
btn.onclick = function() {
  alert('clicked');
}
```

### 内容修改

- `element.innerText` — 忽略HTML标签
- `element.innerHTML` — 识别HTML

## 2021-2-2 更新

### 切换密码可见性

```javascript
var flag = 0;
btn.onclick = function() {
  pwd.type = flag == 0 ? "text" : "password";
  flag = 1 - flag;
};
```

### CSS 修改

使用驼峰命名法：`element.style.backgroundColor = ''`

### 焦点事件

- `element.onfocus` — 获得焦点
- `element.onblur` — 失去焦点

### 节点操作

```javascript
parentNode          // 最近的父节点
children            // 所有子元素
firstElementChild   // 第一个子元素
```

## 垃圾回收

JavaScript 使用**可达性**作为核心内存管理概念。当没有引用指向对象时，对象变为"不可达"，触发自动回收。

![对象可达性示例](/images/posts/2xzqVyIKjRQnbok.png)

![对象变为不可达](/images/posts/lw76DdLcKbvX32h.png)

## 字符串方法

![原始类型的方法示例](/images/posts/2Y8qhBZSI5LCMpV.png)

`indexOf()`、`includes()`、`slice()`、`substring()`、`toUpperCase()`、`toLowerCase()`、`charAt()`

## 数字方法

![浮点数精度问题](/images/posts/ND9QsSZYprmIija.png)

`Math.floor()`、`Math.ceil()`、`Math.round()`、`toFixed(n)`、`parseInt()`、`Math.random()`
