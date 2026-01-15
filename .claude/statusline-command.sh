#!/bin/bash

# Read JSON input
input=$(cat)

# Extract values from JSON (without jq)
cwd=$(echo "$input" | sed -n 's/.*"current_dir":"\([^"]*\)".*/\1/p')

# Git information (skip optional locks for performance)
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  # Get repo name relative to ~/workspace/projects/
  repo_name=$(echo "$cwd" | sed "s|^$HOME/workspace/projects/||")

  # Get branch
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

  # Count staged files
  staged=$(git -C "$cwd" --no-optional-locks diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')

  # Count unstaged files (modified + deleted, not untracked)
  unstaged=$(git -C "$cwd" --no-optional-locks diff --name-only 2>/dev/null | wc -l | tr -d ' ')

  # Count untracked files
  untracked=$(git -C "$cwd" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

  # Dim gray for pipes (\033[90m), white for repo, green for branch, yellow for numbers (no bold)
  dim='\033[90m'
  reset='\033[0m'
  white='\033[37m'
  green='\033[32m'
  yellow='\033[33m'

  printf "${white}%s${reset} ${dim}|${reset} ${green}%s${reset} ${dim}|${reset} S: ${yellow}%s${reset} ${dim}|${reset} U: ${yellow}%s${reset} ${dim}|${reset} A: ${yellow}%s${reset}" \
    "$repo_name" "$branch" "$staged" "$unstaged" "$untracked"
else
  # Not a git repo
  printf '%s' "$cwd"
fi
