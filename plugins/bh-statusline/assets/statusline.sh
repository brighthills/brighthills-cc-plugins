#!/bin/bash

# BrightHills custom status line for Claude Code
# Displays: Model | Git branch | Context left [████░░░░░░] 72% | Directory | Output style
#
# Install target: ~/.claude/statusline-command.sh
# Configured via: ~/.claude/settings.json → statusLine.command

# Read JSON input from stdin
input=$(cat)

# ANSI color codes
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# Colors
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
BLUE='\033[34m'
MAGENTA='\033[35m'

# Extract data from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')

# Initialize status parts
status_parts=()

# Model name (first)
if [ "$model_name" != "null" ] && [ -n "$model_name" ]; then
    status_parts+=("${YELLOW}${BOLD}${model_name}${RESET}")
fi

# Git branch (if in a git repo)
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "detached")
    if [ -n "$branch" ]; then
        status_parts+=("${GREEN}${BOLD}${branch}${RESET}")
    fi
fi

# Context window usage with progress bar (use pre-calculated values from Claude Code)
remaining_pct=$(echo "$input" | jq '.context_window.remaining_percentage')
if [ "$remaining_pct" != "null" ] && [ -n "$remaining_pct" ]; then
    # Choose color based on remaining context
    if [ "$remaining_pct" -gt 40 ]; then
        REMAIN_COLOR="$GREEN"
    elif [ "$remaining_pct" -gt 20 ]; then
        REMAIN_COLOR="$YELLOW"
    else
        REMAIN_COLOR="$RED"
    fi

    # Create compact progress bar (10 characters wide)
    # Bar fills up as context is consumed — full bar = no context left
    remain_filled=$(( (100 - remaining_pct) / 10 ))
    remain_empty=$((10 - remain_filled))

    remain_bar=""
    for ((i=0; i<remain_filled; i++)); do remain_bar="${remain_bar}█"; done

    remain_empty_bar=""
    for ((i=0; i<remain_empty; i++)); do remain_empty_bar="${remain_empty_bar}░"; done

    status_parts+=("${DIM}left:${RESET}${REMAIN_COLOR}[${remain_bar}${DIM}${remain_empty_bar}${REMAIN_COLOR}]${RESET} ${REMAIN_COLOR}${remaining_pct}%${RESET}")
fi

# Current directory
status_parts+=("${BLUE}${BOLD}$(basename "$cwd")${RESET}")

# Output style (at the end)
if [ "$output_style" != "null" ] && [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
    status_parts+=("${MAGENTA}${output_style}${RESET}")
fi

# Join all parts with " | "
output=""
for ((i=0; i<${#status_parts[@]}; i++)); do
    if [ $i -gt 0 ]; then
        output="${output}${DIM} | ${RESET}"
    fi
    output="${output}${status_parts[$i]}"
done

printf "%b" "$output"
