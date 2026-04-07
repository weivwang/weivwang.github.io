---
title: "React再思考"
date: 2021-11-06
tags: ["前端", "React"]
draft: false
---

## 为什么是函数组件？

类组件存在挑战：JavaScript 的 `this` 绑定复杂性以及对编译器优化的限制。

## 理解 React

React 将自己描述为"一个用于构建用户界面的 JavaScript 库"，而非完整的框架。团队将路由和状态管理交给社区，而非提供全面的内置解决方案。

**核心优势：**
- 组件化架构促进高内聚低耦合
- JSX 语法提高代码可读性

## JSX 基础

JSX 是 `React.createElement()` 调用的语法糖。一个 JSX 元素如：

```jsx
<MyButton color="blue">Click Me</MyButton>
```

会编译为带有 type、props 和 children 参数的函数调用。

`import React from 'react'` 语句是必要的，因为 Babel 转译会在代码中隐式调用 `React.createElement()`。

## 虚拟 DOM 性能

React 在内存中维护虚拟 DOM 表示。当数据变化时，React 将新的虚拟树与之前的版本比较，只更新实际 DOM 中的差异部分。

重要优化：**在一个事件循环周期内，多个状态变化会合并在一起**，避免不必要的中间渲染。

## React Fiber（v16+）

这一算法重新设计通过将大型同步任务分割成更小的片段来解决性能瓶颈。这防止单一的 JavaScript 线程被独占，允许其他操作在片段之间执行——类似于 CPU 时间片。

## 生命周期更新

新版本移除了有问题的生命周期方法，引入了 `getDerivedStateFromProps()`，尽管文档不鼓励使用它，因为常见的实现错误。

## Redux 实现

Redux 应用 Flux 架构原则进行状态管理，特别适用于具有复杂用户交互、多用户协作或频繁服务器通信的应用。
