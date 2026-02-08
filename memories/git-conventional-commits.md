---
title: Conventional Commits 1.0.0
source: "Conventional Commits (https://www.conventionalcommits.org/en/v1.0.0/)"
description: "Specification for adding human and machine readable meaning to commit messages."
---

# Conventional Commits Reference

## Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Core Types
- **feat**: a new feature for the user, not a new feature for build script.
- **fix**: a bug fix for the user, not a fix to a build script.
- **docs**: changes to the documentation.
- **style**: formatting, missing semi colons, etc; no production code change.
- **refactor**: refactoring production code, eg. renaming a variable.
- **perf**: code change that improves performance.
- **test**: adding missing tests, refactoring tests; no production code change.
- **chore**: updating grunt tasks etc; no production code change.

## Examples
- `feat(api): add user authentication`
- `fix(auth): handle null token correctly`
- `refactor!: drop support for Node 12` (Breaking Change indicated by `!`)
