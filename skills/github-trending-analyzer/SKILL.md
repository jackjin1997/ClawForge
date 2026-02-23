---
name: github-trending-analyzer
description: Fetch, categorize, and summarize GitHub Trending projects across daily, weekly, and monthly spans. Use when a user asks for "trending projects", "latest hot repos", or a "summary of GitHub trends" to provide a structured, categorised report.
---

# GitHub Trending Analyzer

Use this skill to provide a comprehensive, categorized summary of the latest trending repositories on GitHub.

## Workflow

1.  **Fetch Data**: Use `curl` or `browser` to fetch trending data for three time spans:
    *   Daily: `https://github.com/trending?since=daily`
    *   Weekly: `https://github.com/trending?since=weekly`
    *   Monthly: `https://github.com/trending?since=monthly`
2.  **Extract All**: Do not cherry-pick. Capture all visible repository names, descriptions, and primary languages from the HTML.
3.  **Categorize**: Instead of just listing by time span, group projects into logical technology buckets (e.g., AI Agents, LLM Infra, DevTools, Security).
4.  **Analyze Trends**: Identify overarching themes (e.g., "The rise of CLI-first Agents" or "Local-first RAG trend").
5.  **Report**: Present a clean, structured Markdown report with tables or clear headers.

## Data Extraction Reference

When using `curl`, you can extract basic info with these patterns:
*   **Repo Names**: `grep -A 1 'class="h3 lh-condensed"' | sed -n 's/.*href="\/\([^"]*\)".*/\1/p'`
*   **Descriptions**: Extract text between `<p class="col-9 ...">` tags.

## Categorization Taxonomy

Use these standard categories for consistency:
*   **AI Agents & Frameworks**: Autonomous agents, orchestration, terminal assistants.
*   **LLM Infra & RAG**: Vector DBs, indexing tools, reasoning engines.
*   **Prompt Engineering**: System prompts, leak collections, optimization tools.
*   **Developer Productivity**: CLI tools, IDE plugins, documentation helpers.
*   **Cybersecurity**: Pentesting tools, vulnerability scanners.
*   **Vertical Applications**: Finance AI, media servers, specialized domain tools.

## Example Output Format

### 📅 Summary of Trends
*   **Observation 1**: [Description]
*   **Observation 2**: [Description]

### 🏗️ Categorized Repositories
#### 🤖 AI Agents
| Repo | Span | Description |
| :--- | :--- | :--- |
| user/repo | Daily | ... |
