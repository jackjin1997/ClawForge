---
name: prd-to-ai-agile-workflow
description: Converts a PRD or broad technical requirement into an AI-executable agile workflow with cards, checklists, branch-diff mapping, review gates, and a final comparison report. Use when the user wants PRD review, agile card decomposition, AI execution tracking, implementation branch review, or PRD-to-code traceability.
user-invocable: true
metadata:
  author: JackJin
  version: "1.0"
  category: workflow
---

# PRD to AI Agile Workflow

Use this as a workflow, not just a task splitter. The goal is to move from broad requirement to agile cards, AI execution tracking, implementation review, and final traceability. At key points, plug in more specialized skills when available.

## Privacy Rules

- Do not publish, push, or submit anything externally without explicit user approval.
- Do not include private company names, repo names, branch names, file paths, tickets, code, customer data, or proprietary requirements in reusable artifacts.
- For public versions, replace project-specific examples with generic placeholders.

## Workflow

### 1. PRD Review

Read the PRD, design doc, or technical proposal before creating cards. Extract goals, constraints, risks, ambiguities, required questions, and assumptions. Ask necessary questions first when answers would change scope, sequencing, acceptance criteria, or risk.

Optional plug-in: use a PRD-to-spec or requirements-review skill to turn rough input into a structured spec before card splitting.

### 2. Questions and Assumptions

Separate questions from assumptions. Questions require user or stakeholder answers. Assumptions let work proceed but must appear on affected cards. Do not silently turn unresolved ambiguity into implementation work.

### 3. Initial Agile Card Split

Create cards at traditional agile story granularity. A card should be independently reviewable and verifiable, usually mapping to one focused PR or implementation slice. Do not create one card per tiny code edit; put code-level steps inside the checklist.

Optional plug-in: use a spec-to-tasks, issue-splitting, or agile-card-decomposition skill to generate the first card set, then normalize output to this workflow's card fields.

Each card should include:
- Title
- Source: `initial`
- Scope
- Acceptance criteria
- AI execution checklist
- Dependencies
- Related files/modules when known
- Verification evidence or commands
- Risk level
- Owner type: `AI`, `Human`, or `Mixed`

### 4. Branch Review and Diff Mapping

When an implementation branch or worktree exists, review the actual diff and map changed files/commits back to cards. Update card status, checklist completion, branch-match notes, review comments, and remaining gaps.

Suggested statuses: `Backlog`, `Ready`, `AI In Progress`, `Blocked`, `Human Review`, `Changes Requested`, `Verified`, `Done`.

### 5. Review-Added Cards

If a diff contains work that does not map to an original card, create a card with Source: `review-added`.

Use review-added cards for unscoped feature changes, dependency upgrades, documentation drift, local tooling/report artifacts, test-only changes that affect release decisions, or behavior changes outside the original PRD.

### 6. Technical / Coding Review

Before high-level reporting, review implementation quality: correctness, API compatibility, SQL/query behavior, pagination and boundaries, caching and invalidation, routing/integration fallback, error handling, observability, tests, and build/verification commands.

Ground findings in file/line references when possible. Required fixes must become checklist items or `Changes Requested` notes.

Optional plug-in: use a code-review, testing, debugging, or verification skill for this phase.

### 7. High-Level Review and Comparison Report

After technical review, produce a PRD-to-implementation report covering requirements, matching card IDs, branch diff or commits, implementation status, verification evidence, review findings, remaining gaps, and release decision.

Use this table:

| PRD Item | Card(s) | Implementation | Verification | Status | Notes |
|----------|---------|----------------|--------------|--------|-------|

Status values: `Covered`, `Partially Covered`, `Not Covered`, `Out of Scope`, `Needs Decision`.

## Visual Board Guidance

If the user wants local visualization, create a project-local static HTML board before integrating with issue trackers. Show cards grouped by status, source coloring (`initial` vs `review-added`), priority/risk/owner/coverage tags, checklist counts, branch-match notes, review comments, and final report status.

## Related Skills

Use this workflow as the orchestrator. Use specialized skills at the slot where they fit:

| Slot | Use a specialized skill for |
|------|-----------------------------|
| PRD -> Spec | Structuring rough requirements into a testable spec |
| Spec -> Cards | Splitting a spec into agile cards or tracker issues |
| Card -> Plan | Writing detailed implementation plans per card |
| Plan -> Execution | Implementing approved cards |
| Implementation -> Technical Review | Code review, debugging, testing, verification |
| Review -> Report | Producing traceability and release-readiness reports |

If multiple candidate skills exist, prefer the one that produces the artifact needed by the next workflow step. Keep artifacts compatible with the card fields and report table above.

## Completion Checklist

- [ ] PRD reviewed before card splitting
- [ ] Questions and assumptions recorded
- [ ] Initial agile cards created
- [ ] Implementation diff mapped to cards
- [ ] Review-added cards created for unmapped changes
- [ ] Technical / coding review completed
- [ ] Required fixes tracked
- [ ] Final comparison report produced
- [ ] Public-safe artifacts contain no private project content
