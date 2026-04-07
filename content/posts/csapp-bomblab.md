---
title: "CSAPP BombLab"
date: 2021-11-01
tags: ["CS", "CSAPP"]
draft: false
---

## 背景

CSAPP（Computer Systems: A Programmer's Perspective）的经典实验——拆弹实验。通过逆向工程 x86-64 汇编代码来拆除二进制"炸弹"。

这门课的质量很高，有英文材料、助教演示和丰富的教学经验。

## 环境搭建

使用 macOS，通过 Docker Ubuntu 容器配置必要工具（gcc, gdb, objdump, vim），而非安装虚拟机。

## 方法论

- 使用 `objdump` 反汇编炸弹可执行文件
- 使用 GDB 调试器分析执行
- 阅读汇编代码识别所需输入字符串
- 找到模式以通过每个阶段

## 各阶段解析

### Phase 1：字符串比较

直接字符串匹配——"I am just a renegade hockey mom."

### Phase 2：算术级数

六个整数，等差数列模式：`[0, 1, 3, 6, 10, 15]`

### Phase 3：Switch-Case

Switch-case 语句，需要两个整数进行特定计算。通过跳转表分析有多个有效解。

### Phase 4：递归函数

递归函数分析，带有约束条件。

### Phase 5：数组查找

基于数组的查找与求和逻辑。

### Phase 6：链表操作

链表操作和排序验证，需要更深入的汇编代码分析。

整个实验展示了实际的逆向工程技能和系统化的调试方法论，用于在没有源代码访问的情况下理解编译代码行为。
