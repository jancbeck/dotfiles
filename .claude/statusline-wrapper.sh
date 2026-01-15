#!/bin/bash

input=$(cat)

git_info=$(echo "$input" | bash ~/.claude/statusline-command.sh)

# Get context percentage directly from JSON (official helper pattern)
used=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
pct_num=${used%.*}  # Remove decimal for comparison

# Get model name
model=$(echo "$input" | jq -r '.model.display_name')

# Colors
dim='\033[90m'
reset='\033[0m'
green='\033[32m'
yellow='\033[33m'
red='\033[31m'

# Context color based on percentage
if [ "$pct_num" -lt 40 ] 2>/dev/null; then
  pct_color="$green"
elif [ "$pct_num" -lt 70 ] 2>/dev/null; then
  pct_color="$yellow"
else
  pct_color="$red"
fi

printf "${git_info} ${dim}|${reset} ${pct_color}%.1f%%${reset} ${dim}|${reset} %s" "$used" "$model"
