---
title: "商务智能课堂笔记"
date: 2021-11-18
tags: ["课程笔记"]
draft: false
---

商务智能课堂笔记，对这一部分比较感兴趣。

看PDF应该是老师和百度有合作，内容都是PaddlePaddle提供的。

![image-20211118101711178](/images/posts/slkGtz6MLpEnFoW.png)

![image-20211118101602534](/images/posts/g6NcMXWOvnlwtbE.png)

![image-20211118102252963](/images/posts/yoAmtRuePxgc7h5.png)

## 作业记录

### 1. 三种分析方法

- **描述性分析**：回答"发生了什么？"，使用均值、中位数、方差、相关系数等统计方法分析历史数据。
- **预测性分析**：使用基于概率的技术，包括数据挖掘、统计建模和机器学习（分类、回归、聚类）来预测未来结果及其可能性。
- **规范性分析**：结合描述性和预测性分析的洞察，为企业推荐最优行动方案。

**应用示例**：短视频平台可以使用描述性分析检查观看模式，使用机器学习的预测性分析基于人口统计和历史记录预测用户偏好，使用规范性分析优化内容推荐和定向广告。

### 2. 数据挖掘步骤

八个顺序阶段：

信息收集 → 数据集成 → 数据规约 → 数据清洗 → 数据变换 → 数据挖掘 → 模式评估 → 知识表示

### 3. Apriori算法与FP-Growth算法

**Apriori算法**：频繁项集挖掘

拟定数据：[1,3,4],[2,3,5],[1,2,3,5],[2,5]

最小支持度设置为0.5，最小置信度设置为0.7时，测试结果：

![img](/images/posts/g5TCOWLFoVqEjPS.jpg)

修改最小支持度和最小置信度，分别修改为0.7和0.5，测试结果：

![img](/images/posts/BaLWXitCnlqEr75.jpg)

**FP-Growth算法**：模式提取

测试数据：

![img](/images/posts/cw2i874amMrEHsl.jpg)

测试结果：

![img](/images/posts/BD6ziHM4KOhC8Qf.jpg)

### 4. 决策树算法

信息增益计算

测试结果：

![img](/images/posts/2EMmlRZycCXTK9L.jpg)

### 5. K-means vs K-medoids

关键区别：K-means使用均值计算聚类中心（可能不存在于实际数据中），而K-medoids选择实际数据点作为中心。两种算法的距离计算也不同。

### 6. 层次聚类

使用单连接算法描述数据如何进行层次聚类，并画出树状图。

数据点：（10，8）（70，80）（99，87）（6，5）（5，10）

![image-20211210090953323](/images/posts/s4ZxUkwYCpFH6MI.png)

![image-20211210091036062](/images/posts/whDcVrFRks6XvK2.png)

### 7. 深度学习基础

- 前向传播（Forward Propagation）
- 反向传播（Backpropagation）
- 梯度下降优化（Gradient Descent）
