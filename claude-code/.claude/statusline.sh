#!/bin/bash
# Claude Code status line. Reads session JSON on stdin, prints one line:
#   📁 repo │ 🌿 branch ✓|● │ +ins-del │ 🤖 model │ 🟢 ctx%
# Wired up in ~/.claude/settings.json as {"statusLine":{"type":"command","command":"~/.claude/statusline.sh"}}.
#
# STATUSLINE_BRANCH_MAX  max branch-name length before it is cut with "…" (default 30)

BRANCH_MAX="${STATUSLINE_BRANCH_MAX:-30}"

input=$(cat)
model_name=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
repo_name=$(basename "$current_dir")

git_branch=""
git_status=""
loc_info=""

g() { git -C "$current_dir" --no-optional-locks "$@" 2>/dev/null; }

if git -C "$current_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(g branch --show-current)
  if [ -n "$branch" ]; then
    if [ "${#branch}" -gt "$BRANCH_MAX" ]; then
      branch="${branch:0:$((BRANCH_MAX - 1))}…"
    fi
    git_branch="$branch"
  fi

  untracked=$(g ls-files --others --exclude-standard)
  untracked_ins=$(g ls-files --others --exclude-standard -z \
    | xargs -0 -I{} wc -l "$current_dir/{}" 2>/dev/null | awk '{s+=$1} END{print s+0}')

  if g diff --quiet && g diff --cached --quiet && [ -z "$untracked" ]; then
    git_status="✓"
  else
    git_status="●"
    stats="$(g diff --shortstat) $(g diff --cached --shortstat)"
    ins=$(echo "$stats" | grep -o '[0-9]* insertion' | awk '{s+=$1} END{print s+0}')
    del=$(echo "$stats" | grep -o '[0-9]* deletion' | awk '{s+=$1} END{print s+0}')
    ins=$((ins + untracked_ins))
    loc_info=$(printf " \033[2m│\033[0m \033[32m+%s\033[0m\033[31m-%s\033[0m" "$ins" "$del")
  fi
fi

USAGE=$(echo "$input" | jq '.context_window.current_usage')
CONTEXT_SIZE=$(echo "$input" | jq '.context_window.context_window_size')
if [ "$USAGE" != "null" ]; then
  CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  PERCENT_USED=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
else
  PERCENT_USED=0
fi

if [ "$PERCENT_USED" -lt 50 ]; then
  context_color="\033[32m"; context_icon="🟢"
elif [ "$PERCENT_USED" -lt 80 ]; then
  context_color="\033[33m"; context_icon="🟡"
else
  context_color="\033[31m"; context_icon="🔴"
fi
context_info=$(printf " \033[2m│\033[0m %s ${context_color}%d%%\033[0m" "$context_icon" "$PERCENT_USED")

if [ -n "$git_branch" ]; then
  printf "\033[36m📁 %s\033[0m \033[2m│\033[0m \033[35m🌿 %s %s\033[0m%s \033[2m│\033[0m \033[95m🤖 %s\033[0m%s" \
    "$repo_name" "$git_branch" "$git_status" "$loc_info" "$model_name" "$context_info"
else
  printf "\033[36m📁 %s\033[0m \033[2m│\033[0m \033[95m🤖 %s\033[0m%s" \
    "$repo_name" "$model_name" "$context_info"
fi
