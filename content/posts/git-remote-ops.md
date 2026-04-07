---
title: "Git关联及取消关联远程仓库操作"
date: 2021-04-28
tags: ["Git"]
draft: false
---

在上传 iOS 作业到 GitHub 时遇到的仓库关联问题及解决方案。

## 关键操作

### 初始化仓库

```bash
git init
```

### 关联本地和远程仓库

```bash
git remote add origin git@github.com:username/projectname.git
```

### 验证关联

```bash
git remote -v
```

### 创建主分支

```bash
git branch -M main
```

### 推送到远程仓库

```bash
git push -u origin main
```

### 取消关联

```bash
git remote remove origin
```
