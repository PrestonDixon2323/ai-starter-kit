#!/bin/bash
# Claude Code status line: shows current folder, git branch (with a * when
# there are uncommitted changes), and the active model.
# Claude Code runs this script and pipes session info to it as JSON on stdin.
#
# Install:
#   cp statusline.sh ~/.claude/statusline.sh && chmod +x ~/.claude/statusline.sh
# then add to ~/.claude/settings.json:
#   "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }

input=$(cat)

# Pull fields from the session JSON (fall back gracefully if jq is missing).
if command -v jq >/dev/null 2>&1; then
  cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
  model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
else
  cwd="$PWD"
  model=""
fi
[ -z "$cwd" ] && cwd="$PWD"

dir=$(basename "$cwd")

# Git branch + dirty state, only if inside a work tree.
branch=""
dirty=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
    dirty="*"
  fi
fi

# ANSI colors (dim and subtle so it doesn't shout).
BLUE=$'\033[34m'
YELLOW=$'\033[33m'
DIM=$'\033[2m'
RESET=$'\033[0m'

out="${BLUE}${dir}${RESET}"
if [ -n "$branch" ]; then
  out="${out} ${DIM}on${RESET} ${YELLOW}${branch}${dirty}${RESET}"
fi
if [ -n "$model" ]; then
  out="${out} ${DIM}·${RESET} ${DIM}${model}${RESET}"
fi

printf '%s' "$out"
