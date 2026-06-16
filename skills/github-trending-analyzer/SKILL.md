---
name: github-trending-analyzer
description: Fetch, categorize, and summarize GitHub Trending projects across daily, weekly, and monthly spans. Use when a user asks for "trending projects", "latest hot repos", or a "summary of GitHub trends" to provide a structured, categorised report with full hyperlinking. Supports Markdown, HTML (Pinterest design), or both output formats, with optional Obsidian vault storage.
---

# GitHub Trending Analyzer

Provide a comprehensive, categorized summary of the latest trending repositories on GitHub.

## Step 0: Ask Output Format

**Before doing anything else**, ask the user:

> 你想要哪种输出格式？
> 1. **📝 Markdown** — 对话中展示 + 存入 Obsidian
> 2. **🎨 HTML** — Pinterest 风格网页 + 存入 Obsidian
> 3. **📝+🎨 Both** — 两个都要
>
> （直接回复 1/2/3 或 md/html/both）

If the user already specified a format in their command arguments (e.g., `html`, `md`, `both`), skip the question and proceed directly. Default to **Markdown** if no clear preference.

## Step 1: Fetch Data

The shell script may fail due to GitHub HTML changes. Use this **fallback strategy**:

1. **Try the script first**: `scripts/fetch_trending.sh daily|weekly|monthly`
2. **If empty results**, fall back to `gh api` with GitHub Search API:
   - **Daily proxy** (active high-star repos pushed in last 7 days):
     ```
     gh api "search/repositories?q=stars:>1000+pushed:>YYYY-MM-DD&sort=stars&order=desc&per_page=30"
     ```
   - **Weekly** (new repos created in last 7 days, sorted by stars):
     ```
     gh api "search/repositories?q=created:>YYYY-MM-DD&sort=stars&order=desc&per_page=30"
     ```
   - **Monthly** (new repos created in last 30 days, sorted by stars):
     ```
     gh api "search/repositories?q=created:>YYYY-MM-DD&sort=stars&order=desc&per_page=30"
     ```
   - **Today's hottest** (high-star repos pushed today):
     ```
     gh api "search/repositories?q=stars:>5000+pushed:>YYYY-MM-DD&sort=updated&order=desc&per_page=25"
     ```
   - **Brand new** (created in last 2 days):
     ```
     gh api "search/repositories?q=created:>YYYY-MM-DD&sort=stars&order=desc&per_page=20"
     ```
3. Use `--jq` to extract: `full_name`, `language`, `stargazers_count`, `description`, `created_at`

## Step 2: Full Inventory & Deduplication

- List every single project found. Do not omit any.
- Note projects appearing in multiple spans (e.g., "Daily + Monthly").

## Step 3: Deep Categorization (2-Level Hierarchy)

**Use a 2-level taxonomy** when total projects > 30 — flat single-level becomes a wall of cards. Single-level is fine for &lt; 30 projects.

### Method: explicit `full_name → (macro, sub)` mapping

Keyword-heuristic categorization (`if 'skill' in desc and ...`) leaves ~20% of projects in a useless "other" bucket. **Explicit per-project mapping** is 100% coverage and faster to maintain at this scale (≤ 200 projects). See `references/hierarchical-classification.md` for the canonical pattern.

### Recommended 7 macro themes

These are starting points — adjust based on what today's data actually surfaces:

- **🤖 AI Native 开发栈** — Skills, AI 编码 CLI, agent harness, LLM 平台, AI workspace, 评估/可观测, MCP/SDK
- **🎨 模型 & 创意生成** — 大模型, 多模态生成, 模型硬件
- **🛡️ 安全 & 防御** — 防御/威胁建模, 供应链/扫描, OSINT, dual-use 漏洞
- **🛠️ 工程 & 生产力** — macOS/iOS, 终端, Web, 数据集成, 业务/SaaS 替代
- **🔬 研究 & 学习资源** — 教育资源, awesome 清单, RAG/知识系统
- **🌳 平台 & 经典基础设施** — 前端框架, 系统/内核, 通用开发工具
- **🌎 其它** — 可疑/Game exploit, 无描述, 游戏移植

### Sub-buckets emerge from the data

Don't pre-fix sub-buckets — let the data shape them. Example from 2026-06-16 run: Skills macro naturally split into 5 subs (创意/媒体, 写作/语言, 工作流/方法论, 研究/学术, 通用集合) once the 19 projects were laid out. Resist over-engineering: 3-7 subs per macro is the sweet spot.

### No "other" catch-all

If "其它" exceeds 8 projects, force them into named buckets even if narrow (e.g. `⚠️ 可疑/Game exploit`, `❓ 无描述/不明`, `🎮 游戏移植`). This makes suspicious items more visible, not less.

## Step 4: Hyperlinking

Every project MUST include its full GitHub URL: `[user/repo](https://github.com/user/repo)`

## Step 5: Strategic Insights

Identify 3-5 high-level trends. Include a one-sentence "vibe summary" of the day.

## Step 6: Output

Based on the user's format choice:

### Markdown (option 1)

Output in conversation:

```
# GitHub Trending 全景分析（YYYY-MM-DD）

## 📅 Part 1：完整热门列表
### 🔴 每日热门（Daily）  — table
### 🟡 每周热门（Weekly） — table
### 🟢 每月热门（Monthly）— table

## 🏗️ Part 2：分类分析
(One table per category)

## 💡 Part 3：战略洞察
(3-5 insights + vibe summary)
```

### HTML (option 2)

Generate a single self-contained HTML file following the design spec in `references/pinterest-design.md`. Open in browser with `open <path>`.

For longer reports (≥ 6 macro sections), include a **floating mini-TOC** as specified in the design doc — fixed right-side panel with scroll-spy and collapsible sub-buckets. Avoid the inline full-width TOC: it eats first-screen real estate.

### Both (option 3)

Show Markdown in conversation AND generate the HTML file.

## Step 7: Save to Obsidian

After generating, save to the Obsidian vault:

- **Vault path**: Read `~/Library/Application Support/obsidian/obsidian.json`, pick the accessible vault.
- **Folder**: `GitHub-Trending/`
- **Markdown**: `GitHub-Trending/YYYY-MM-DD.md` with frontmatter:
  ```yaml
  ---
  date: YYYY-MM-DD
  type: github-trending
  tags: [github, trending, AI, open-source]
  ---
  ```
- **HTML**: `GitHub-Trending/YYYY-MM-DD.html`
- Only save the format(s) the user requested.
- If the vault is not accessible (permission error), save to the working directory and inform the user.

## Language

If the user passes `中文` as argument, output everything in Chinese. Otherwise default to English.
