#!/usr/bin/env bash

if [[ -n "${TMUX_GIT_WORKTREE_FUNCTIONS_LOADED:-}" ]]; then
  return 0
fi
TMUX_GIT_WORKTREE_FUNCTIONS_LOADED=1

# Provides shared utility functions for mapping git worktrees to tmux sessions.
# Takes any commit-ish (branch name, tag, ref) and derives a tmux session name
# and worktree path directly from it. The ref is sanitized for tmux compatibility:
# slashes become "__" and dots are stripped.
#
#   feature/login  ->  session: myrepo-worktree-feature__login
#                      path:    /path/to/myrepo-worktree-feature__login
#
# Usage:
#   git branch feature/login
#   gw-new feature/login          # creates worktree + tmux session, switches to it
#   gw-switch feature/login       # switch back to it later
#   gw-yoink feature/login        # copy the worktree path to clipboard
#   gw-delete feature/login       # remove worktree and kill session
#
# Functions:
#   gw-new <branch>      Create a worktree + tmux session and switch to it
#   gw-switch <branch>   Switch to an existing worktree's session (creates if needed)
#   gw-yoink <branch>    Copy a worktree's path to the clipboard
#   gw-delete <branch>   Remove a worktree and kill its tmux session


missing_deps=0
for cmd in git tmux fzf pbcopy; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "tmux-git-worktree: missing dependency: $cmd" >&2
    missing_deps=1
  fi
done
if [[ "$missing_deps" -eq 1 ]]; then
  return 1
fi

_gw-primary-worktree() {
  git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print $2; exit}'
}
export -f _gw-primary-worktree

_gw-branch-to-session() {
  local branch="$1"
  local primary_worktree=$(_gw-primary-worktree)
  local session_name="$(basename $primary_worktree)-worktree-${branch}"
  session_name=${session_name//\//__}
  session_name=${session_name//.//}
  echo $session_name
}
export -f _gw-branch-to-session

_gw-worktree-path() {
  local branch="$1"
  local primary_worktree=$(_gw-primary-worktree)
  local sanitized="${branch//\//__}"
  sanitized="${sanitized//.//}"
  echo "${primary_worktree}-worktree-${sanitized}"
}
export -f _gw-worktree-path

_gw-run-bootstrap-script() {
  local session_name="$1"
  local bootstrap_script="${2:-./scripts/bootstrap-worktree.sh}"
  local post_bootstrap_command="${3:-}"

  if [[ -f $bootstrap_script ]]; then
    if [[ -n "$post_bootstrap_command" ]]; then
      tmux send-keys -t "$session_name" "$bootstrap_script && $post_bootstrap_command" Enter
    else
      tmux send-keys -t "$session_name" "$bootstrap_script" Enter
    fi
  elif [[ -n "$post_bootstrap_command" ]]; then
    tmux send-keys -t "$session_name" "$post_bootstrap_command" Enter
  fi
}
export -f _gw-run-bootstrap-script

gw-new() {
  if [[ -z "$1" ]]; then
    echo "Usage: gw-new <branch> [bootstrap script] [post-bootstrap command]" >&2
    return 1
  fi
  local branch="$1"
  local path=$(_gw-worktree-path "$branch")
  local session_name=$(_gw-branch-to-session "$branch")

  if tmux has-session -t "$session_name" 2> /dev/null; then
     tmux switch-client -t "$session_name";
  else
    git worktree add "$path" "$branch" \
      && tmux new-session -c "$path" -s "$session_name" -d \
      && tmux switch-client -t "$session_name" \
      && _gw-run-bootstrap-script "$session_name" "${2:-}" "${3:-}";
  fi
}
export -f gw-new

gw-switch() {
  if [[ -z "$1" ]]; then
    echo "Usage: gw-switch <branch>" >&2
    return 1
  fi
  local branch="$1"
  local path="$(git worktree list | grep -F "[$branch]" | cut -d' ' -f1)"

  session_name=$(_gw-branch-to-session $branch)

  if ! [[ -d "$path" ]]; then
    gw-new $branch
    return 0
  fi

  local primary_worktree=$(_gw-primary-worktree)
  if [[ "$path" == "$primary_worktree" ]]; then
    local base
    base=$(basename "$primary_worktree")
    session_name="${base//./}"
  fi

  if tmux has-session -t "$session_name" 2> /dev/null; then
     tmux switch-client -t "$session_name";
  else
      tmux new-session -c "$path" -s "$session_name" -d;
      tmux switch-client -t "$session_name";
  fi
}
export -f gw-switch

gw-yoink() {
  if [[ -z "$1" ]]; then
    echo "Usage: gw-yoink <branch>" >&2
    return 1
  fi
  local branch="$1"
  local path="$(git worktree list | grep -F "[$branch]" | cut -d' ' -f1)"
  if [[ -z "$path" ]]; then
    echo "No worktree found for branch: $branch" >&2
    return 1
  fi
  printf '%s\n' "$path" | pbcopy
  printf 'Copied worktree path: %s\n' "$path"
}
export -f gw-yoink

gw-delete() {
  if [[ -z "$1" ]]; then
    echo "Usage: gw-delete <branch>" >&2
    return 1
  fi
  local branch="$1"
  local primary_worktree=$(_gw-primary-worktree)
  local path="$(git worktree list | grep -F "[$branch]" | cut -d' ' -f1)"

  if [[ -z "$path" || "$path" == "$primary_worktree" ]]; then
    echo "Refusing to delete primary worktree: $path" >&2
    return 1
  fi

  local session_name=$(_gw-branch-to-session "$branch")
  if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux kill-session -t "$session_name"
  fi

  git worktree remove --force "$path"
}
export -f gw-delete

_gw-delete-concurrently() {
  local worktree_count=$#
  local failed_deletions=0
  local process_ids=()
  local branch
  local process_id

  for branch in "$@"; do
    gw-delete "$branch" &
    process_ids+=("$!")
  done

  for process_id in "${process_ids[@]}"; do
    if ! wait "$process_id"; then
      failed_deletions=$((failed_deletions + 1))
    fi
  done

  if [[ "$failed_deletions" -eq 0 ]]; then
    tmux display-message -d 5000 "Deleted ${worktree_count} worktrees"
  else
    tmux display-message -d 5000 \
      "Deleted worktrees with ${failed_deletions} failures"
  fi

  return "$failed_deletions"
}
export -f _gw-delete-concurrently

_branches() {
  local branches
  branches=$(git branch --format='%(refname:short)' 2>/dev/null)
  COMPREPLY=($(compgen -W "$branches" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _branches gw-new
complete -F _branches gw-switch
_worktrees() {
  local branches
  branches=$(git worktree list --porcelain 2>/dev/null | awk '/^branch /{sub(/.*\//, ""); print}')
  COMPREPLY=($(compgen -W "$branches" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _worktrees gw-delete
complete -F _worktrees gw-yoink
