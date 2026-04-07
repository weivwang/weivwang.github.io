---
title: "JavaEE课堂笔记"
date: 2021-10-23
tags: ["Java", "课程笔记"]
draft: false
---

## 第一周

**核心框架栈**：Spring-SpringMVC-Mybatis（SSM）

- **Spring**：通用框架，解决基础架构问题
- **Mybatis**：ORM库，实现对象关系映射
- **SpringMVC**：Web开发框架

### 框架 vs 中间件

框架以SDK或JAR包形式交付，中间件独立运行，不依赖应用代码。

### 设计原则

课程强调面向对象编程的 **SOLID原则**，特别关注：

- **IoC（控制反转）**：将对象创建委托给Spring容器，而非手动实例化，以防止编译时耦合
- **DI（依赖注入）**：通过容器建立运行时依赖

### 反射模式

使用反射代替直接对象实例化，解耦编译和运行时：

```java
this.engine = (IEngine)Class.forName("com.demo.Engine").newInstance();
```

允许在不重新编译的情况下更改配置。

### AOP（面向切面编程）

通过在运行时修改行为来解决静态类型语言的扩展性挑战。

## 第二周

### 核心类

**Object类和Class类**是Java类型系统的基础。

### 注解

`@Component` 注解示例：

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
```

`@Retention` 策略决定生命周期：
- **SOURCE**：仅源码
- **CLASS**：字节码
- **RUNTIME**：JVM加载

## 第三周

### 内存管理

内存泄漏发生在对象超出其操作必要性时仍然存在。Java通过以下方式实现垃圾回收：

1. 引用计数法
2. 标记-清除追踪算法
