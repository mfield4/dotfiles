#!/usr/bin/env bash
# Claude Code status line
# Format: [model] cwd (git branch) — <used tokens>
#
# Reads the status line JSON payload from stdin (see Claude Code
# statusLine documentation for the full schema).

input="$(cat)"

model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "model"')

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
project_dir=$(printf '%s' "$input" | jq -r '.workspace.project_dir // empty')

# Prefer a workspace-relative path (project_dir basename + relative path),
# falling back to a "~"-abbreviated home-relative path.
display_cwd="$cwd"
if [ -n "$project_dir" ] && [ "${cwd#"$project_dir"}" != "$cwd" ]; then
    display_cwd="$(basename "$project_dir")${cwd#"$project_dir"}"
elif [ -n "$HOME" ] && [ "${cwd#"$HOME"}" != "$cwd" ]; then
    display_cwd="~${cwd#"$HOME"}"
fi

# Git branch for cwd's repo; silently omitted (with its parens) when cwd
# isn't inside a git repo. --no-optional-locks keeps this safe to run
# concurrently with other git activity.
branch=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

# Current used tokens. Prefer the raw token counts (input tokens currently
# in the context window + the most recent response's output tokens); fall
# back to deriving it from context_window_size * used_percentage when only
# the percentage is available. Omitted entirely when no usage data is
# available yet (e.g. before the first API response).
input_tokens=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')
output_tokens=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // empty')
window_size=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

used_tokens=""
if [ -n "$input_tokens" ]; then
    used_tokens=$(( input_tokens + ${output_tokens:-0} ))
elif [ -n "$window_size" ] && [ -n "$used_pct" ]; then
    used_tokens=$(awk -v s="$window_size" -v p="$used_pct" 'BEGIN{printf "%.0f", s*p/100}')
fi

# Human-readable: raw integer below 1k, "231.5k" style below 1m, "1.2m" style at/above 1m.
used_display=""
if [ -n "$used_tokens" ]; then
    used_display=$(awk -v n="$used_tokens" 'BEGIN{
        if (n < 1000) printf "%d", n
        else if (n < 1000000) printf "%.1fk", n/1000
        else printf "%.1fm", n/1000000
    }')
fi

# Colors (dimmed-friendly ANSI codes, in the spirit of the robbyrussell taste).
GREEN=$'\033[32m'
CYAN=$'\033[36m'
YELLOW=$'\033[33m'
DIM=$'\033[2m'
RESET=$'\033[0m'

line="${GREEN}[${model}]${RESET} ${CYAN}${display_cwd}${RESET}"

if [ -n "$branch" ]; then
    line="${line} ${YELLOW}(${branch})${RESET}"
fi

if [ -n "$used_display" ]; then
    line="${line} ${DIM}—${RESET} ${used_display}"
fi

# Claude.ai subscription 5-hour rate limit usage, appended right after the
# context usage. Omitted when not present (e.g. non-subscribers, or before
# the first API response).
rate_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
resets_at=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

rate_display=""
if [ -n "$rate_pct" ]; then
    rate_display=$(awk -v p="$rate_pct" 'BEGIN{printf "%.0f%%", p}')
fi

# Time remaining until the rate-limit window resets, formatted compactly
# (e.g. "2h13m left"). Omitted when the reset timestamp isn't available or
# has already passed.
time_left_display=""
if [ -n "$resets_at" ]; then
    now_epoch=$(date +%s)
    remaining_secs=$(awk -v r="$resets_at" -v n="$now_epoch" 'BEGIN{printf "%d", r-n}')
    if [ "$remaining_secs" -gt 0 ]; then
        time_left_display=$(awk -v s="$remaining_secs" 'BEGIN{
            h=int(s/3600)
            m=int((s%3600)/60)
            if (h > 0) printf "%dh%dm left", h, m
            else printf "%dm left", m
        }')
    fi
fi

if [ -n "$rate_display" ]; then
    line="${line} ${DIM}(${RESET}${rate_display}"
    if [ -n "$time_left_display" ]; then
        line="${line} ${DIM}·${RESET} ${time_left_display}"
    fi
    line="${line}${DIM})${RESET}"
fi

printf '%s\n' "$line"
