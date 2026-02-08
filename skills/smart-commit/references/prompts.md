# LLM Prompts for Commit Message Generation

## New Commit

Generate a concise, meaningful git commit message based on the following changes:

### Input Format
```
File: <filepath>
@@ -<line> +<line> @@
<diff content>
```

### Output Requirements
- Maximum 72 characters for subject line
- Use imperative mood ("Add feature" not "Added feature")
- Include ticket/reference number if present in context
- Separate subject from body with blank line

### Example Output
```
feat(auth): add JWT token validation

Implement token validation middleware with expiration check.
Handle token refresh scenario for expired but valid tokens.
```

---

## Amend Commit

The user wants to amend the last commit with additional changes. Generate an updated commit message that:
- Incorporates the original commit message
- Reflects the new changes shown in the diff
- Maintains consistent type/scope format

### Input Format
```
Original commit message:
<original message>

New changes to incorporate:
<diff content>
```

### Output Requirements
- If changes are minor: suggest minor message update
- If changes are significant: suggest new message
- Keep original intent while adding new context
- Maximum 72 characters for subject

---

## Squash Commits

Consolidate multiple git commits into a single meaningful commit message.

### Input Format
```
Commit 1 of N:
<hash> | <original message> | <author> | <date>
<diff>

Commit 2 of N:
<hash> | <original message> | <author> | <date>
<diff>
...
```

### Output Requirements
- Identify the common theme across all commits
- Generate one coherent commit message
- Use the most significant change as primary type
- Mention important sub-changes if relevant
- Follow conventional commits format

### Example
If commits are:
- "fix typo in README"
- "update installation steps"
- "add troubleshooting section"

Output:
```
docs: improve installation documentation

- Fix typo in README
- Update installation prerequisites
- Add troubleshooting section for common issues
```

---

## Style Guidelines

### Conventional Commits Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Common Types
| Type | Description |
|------|-------------|
| feat | New feature |
| fix | Bug fix |
| docs | Documentation only |
| style | Formatting, missing semicolons, etc. |
| refactor | Code change neither fix nor add feature |
| test | Adding/missing tests |
| chore | Maintenance tasks |

### Best Practices
1. Use lowercase for type and scope
2. Capitalize subject line
3. No trailing period in subject
4. Use simple present tense
5. Focus on "why" not "what"
