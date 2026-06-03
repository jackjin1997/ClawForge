---
name: codebase-to-course
description: Turn a local folder or GitHub repository into an interactive browser-based course that explains how the codebase works for non-expert programmers and AI-assisted builders. Use when a user asks to make a course, tutorial, walkthrough, learning guide, codebase explanation, or interactive lesson from a project.
user-invocable: true
---

# Codebase to Course

Use this skill to transform a real codebase into a polished, interactive course that runs in a browser. The audience is usually an AI-assisted builder who can describe software in natural language but needs enough technical understanding to debug, steer coding agents, and discuss architecture clearly.

## Source Attribution

This Codex skill is inspired by and adapted from Zara Zhangrui's `codebase-to-course` Claude Code skill:

- Repository: https://github.com/zarazhangrui/codebase-to-course
- Upstream concept: turn a codebase into an interactive course with plain-English code explanations, animated flows, quizzes, and glossary tooltips.
- Adaptation notes: this version is rewritten for Codex workflows and avoids copying upstream template assets verbatim. Check upstream licensing before redistributing any original upstream files.
- Accessed: 2026-06-01

## When The User Has Not Named A Codebase

If the request is vague, briefly ask for one target:

- A local folder path
- A GitHub repository URL
- The current working directory

If the user says "this repo", "this project", or similar, use the current working directory. If the user provides a GitHub URL, clone it to a temporary or workspace path before analysis.

## Output

Create a course directory, not a planning document. A typical output structure is:

```text
course-name/
  index.html
  styles.css
  main.js
  modules/
    01-intro.html
    02-actors.html
    03-data-flow.html
```

For small courses, a single self-contained `index.html` is acceptable if that is simpler and the user did not request reusable files. For larger courses, keep CSS, JS, and module HTML separate.

The course must open directly in a browser. Avoid build systems unless the target project already has a static-site workflow the user wants to use.

## Workflow

1. **Inspect the codebase**
   - Read the README, package/config files, entry points, routing, UI surfaces, API handlers, schemas, tests, and deployment files.
   - Identify the main actors: modules, components, services, jobs, databases, external APIs, and user-facing flows.
   - Trace one or two concrete journeys from user action to code execution and output.

2. **Design the learning arc**
   - Build 4-6 modules for most projects.
   - Start from a familiar user action, then move toward internals.
   - Prefer fewer modules with stronger examples over a broad tour.
   - Each module must explain why the concept helps the learner steer AI, debug failures, or make better product decisions.

3. **Write from real code**
   - Use actual code snippets from the target project.
   - Include file paths and line references when practical.
   - Do not invent simplified code and present it as project code.
   - Translate code into plain English beside or below the snippet.

4. **Add interaction**
   - Include at least one quiz per module.
   - Include at least one data-flow or message-flow animation across the course.
   - Include at least one component conversation or handoff visualization across the course.
   - Define glossary tooltips on first use of technical terms in each module.

5. **Assemble and verify**
   - Open or serve the course locally.
   - Check desktop and mobile widths.
   - Confirm quizzes, tooltips, navigation, and animations work.
   - Fix text overflow, blank sections, broken anchors, and unreadable contrast.

## Curriculum Shape

Use this default module menu and adapt it to the project:

| Module | Purpose |
| --- | --- |
| 1. What this app does | Explain the product and trace one real user action into the code. |
| 2. The cast of characters | Introduce the key files, modules, components, and services. |
| 3. How data moves | Show requests, events, state changes, API calls, queues, or database reads/writes. |
| 4. The outside world | Explain dependencies, APIs, authentication, storage, deployment, and runtime constraints. |
| 5. Patterns and tradeoffs | Teach architectural choices, caching, error handling, validation, or performance techniques. |
| 6. Debugging map | Show likely failure points and how to investigate them. |

## Teaching Rules

- Assume limited formal CS background, but do not talk down to the learner.
- Define jargon the first time it appears.
- Keep paragraphs short and visual density high.
- Explain "why this matters" before deep technical detail.
- Use concrete project behavior instead of abstract examples.
- Quizzes should test applied judgment, not trivia.
- Avoid asking the user to approve the curriculum unless they explicitly requested a plan first.

## Design Rules

- Build the actual course as the first screen; do not create a marketing landing page.
- Use a restrained, readable interface with stable layout dimensions.
- Use diagrams, flow rows, timelines, tabs, cards for repeated lessons, and tooltips where they clarify the code.
- Avoid one-note color palettes, oversized decorative hero sections, and text-heavy slides.
- Ensure text fits on mobile and desktop.

## Reference

Read `references/course-patterns.md` when you need concrete HTML patterns for modules, quizzes, code translations, tooltips, and flow animations.
