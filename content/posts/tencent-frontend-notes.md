---
title: "腾讯文档&武大前端菁英班笔记"
date: 2021-11-20
tags: ["前端"]
draft: false
---

## Week 1：前端基础 & ES6

前端三大支柱：HTML（结构）、CSS（表现）、JavaScript（行为）。

主要内容：
- 语义化 HTML5 标签
- CSS 选择器、Flexbox 布局、定位
- DOM 操作
- 函数、对象、闭包、原型链

## Week 2：TypeScript & React

TypeScript 是"JavaScript 的类型超集"，在编译时进行静态类型检查。

主要内容：
- React 组件化架构
- 虚拟 DOM 与 Diff 算法
- NPM 包管理基础

## Week 3：构建工具 & Web 基础

深入探索 webpack 作为主要构建工具，回顾从 Gulp、Grunt 等早期工具的演进。

### webpack

一切皆模块，通过loader转换文件，plugin注入钩子实现

各版本：

![image-20211120101517055](/images/posts/LRStaP4XI7peqxn.png)

#### 基本使用

![image-20211120101644649](/images/posts/maj8pNAzy7CvLhs.png)

Mode:
- Development: 不压缩，调试
- Production：压缩，开启优化选项

#### 进阶使用

##### ES6配置

![image-20211120105822869](/images/posts/5LecXmMhiztQgCj.png)

##### 页面代码加载优化

1、按需加载：大型网站打开时加载全部代码，会导致页面加载缓慢。使用异步加载的方式，按需加载和使用

![image-20211120112625848](/images/posts/sAxdIBNMOcVPRpL.png)

2、提取公共代码：打包时会把公共部分打包在一个文件中

### HTTP/HTTPS

#### GET和POST区别

![image-20211120141948799](/images/posts/zl5xBq8iwkQLXnf.png)

#### HTTP状态码

![image-20211120142308910](/images/posts/5dpBuZ1SI8tfVz2.png)

#### 思考：为什么HTTP是无连接无状态？

前提：基于TCP，减轻服务端压力，不用保持链接状态

![image-20211120142853725](/images/posts/I1o5dFx8VMtlBYi.png)

Http1.1的优化

![image-20211120143049907](/images/posts/5a4ZcelGKJhrLBb.png)

#### HTTPS

![image-20211120143700840](/images/posts/UKZrQLjbTz6MoNu.png)

#### 思考：服务器怎么向客户端推送消息

- 短轮询：特定时间间隔由浏览器对服务器发出HTTP request
- 长轮询：客户端向服务器发送Ajax请求，服务器接到请求后hold住连接，直到有新消息才返回响应信息并关闭连接

![image-20211120144400146](/images/posts/5HBktN4mjhixd18.png)

缺点：服务器端一直保持链接，占用资源。解决方法：SSE，WebSocket

### 缓存

#### 浏览器缓存

浏览器获取的http资源，保存到本地磁盘

![image-20211120151233916](/images/posts/ck5RjW3H4fbXelL.png)

#### 强缓存和协商缓存区别

区别在于需不需要向服务器请求

![image-20211120152725402](/images/posts/wGeEasPrfvuoLTO.png)

缓存过程

![image-20211120152618378](/images/posts/Gm9U4O3Q5r2ybdD.png)

### 安全：XSS 和 CSRF 攻击

## Week 4：工程化 & 设计模式

### 前端工程化和编码规范

- ESLint、Prettier、Husky

husky：解决git commit有时候忘记eslint或prettier

![image-20211127101536124](/images/posts/InwVsxga6GWQMAp.png)

Lint staged：只检查当前改动的eslint，防止把别人的错误检查出来

### Jest单测

- 更少的问题排查时间
- 更准确的文档
- 更方便的代码审核

![image-20211127105746414](/images/posts/M35Ty1Omv4tDnaR.png)

### 设计模式

#### 发布-订阅模式

定义对象间一对多的依赖关系，当一个对象的状态发生变化时，所有依赖于它的对象都将得到通知

![image-20211127114412606](/images/posts/LJvbqyolZuHmMzs.png)

加一个中介：

![image-20211127114726545](/images/posts/K2maZGV1tkHPgEo.png)

#### 其他模式

- 单例模式、享元模式、装饰者模式、工厂模式

### 设计原则

- 单一职责、开闭原则、依赖倒置
