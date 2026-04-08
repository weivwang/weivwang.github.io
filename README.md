# www's Blog

> 使其中坦然，不以物伤性，将何适而非快

个人博客，基于 Hugo 构建，自建 ink 主题。

博客地址：https://weivwang.github.io

## 快速发布

将本地 Markdown 文件一键发布到博客：

```bash
./scripts/publish.sh <markdown文件路径> "标签1,标签2"
```

**示例：**

```bash
# 发布一篇带标签的文章
./scripts/publish.sh ~/Documents/my-post.md "前端,React"

# 发布 Obsidian 文档
./scripts/publish.sh "/Users/wangweiwei/Documents/Obsidian Vault/LLM思考/从信息论的视角再看大语言模型.md" "LLM,信息论,AI"

# 发布已有 front matter 的文章（标签可省略）
./scripts/publish.sh ./article-with-frontmatter.md
```

脚本会自动：
1. 从文件名或一级标题提取标题
2. 补全 front matter（title、date、tags）
3. 复制到 `content/posts/`
4. Git commit & push
5. GitHub Actions 自动构建部署

## 本地预览

```bash
hugo server -D
```

然后打开 http://localhost:1313

## 项目结构

```
├── content/posts/          # 博客文章
├── content/about.md        # 关于页面
├── themes/ink/             # 自建主题
├── scripts/publish.sh      # 快速发布脚本
├── .github/workflows/      # GitHub Actions 自动部署
└── config.toml             # Hugo 配置
```
