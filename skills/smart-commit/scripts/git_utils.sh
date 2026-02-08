#!/bin/bash
# Git utility functions for smart-commit skill

# Get staged changes diff
get_staged_diff() {
    git diff --cached --no-color 2>/dev/null
}

# Get all changes since last commit
get_all_changes() {
    git diff HEAD~1 --no-color 2>/dev/null
}

# Get combined diff for last N commits
get_squash_diff() {
    local n="${1:-3}"
    git diff "HEAD~${n}..HEAD" --no-color 2>/dev/null
}

# Get modified files status
get_status() {
    git status --porcelain 2>/dev/null
}

# Get last N commit summaries
get_last_commits() {
    local n="${1:-5}"
    git log -n "$n" --format="%H|%s|%an|%ad" --date=short 2>/dev/null
}

# Get diff for specific files
get_files_diff() {
    local files=("$@")
    git diff --no-color -- "${files[@]}" 2>/dev/null
}

# Stage specific files
stage_files() {
    local files=("$@")
    git add -- "${files[@]}" 2>/dev/null
}

# Create new commit
create_commit() {
    local message="$1"
    git commit -m "$message" 2>/dev/null
}

# Amend last commit
amend_commit() {
    local message="$1"
    git commit --amend -m "$message" 2>/dev/null
}

# Squash last N commits
squash_commits() {
    local n="$1"
    local message="$2"
    git reset --soft "HEAD~${n}" 2>/dev/null
    git commit -m "$message" 2>/dev/null
}

# Get current branch
get_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Check if git repo
is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}
