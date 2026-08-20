#!/usr/bin/env bash
# Provides a set of utility functions for mapping git worktrees to tmux sessions.
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
#   open-worktree                 # interactive fzf picker for the above
#
# Functions:
#   gw-new <branch>      Create a worktree + tmux session and switch to it
#   gw-switch <branch>   Switch to an existing worktree's session (creates if needed)
#   gw-yoink <branch>    Copy a worktree's path to the clipboard
#   gw-delete <branch>   Remove a worktree and kill its tmux session
#   open-worktree        Interactive fzf picker for the above operations


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

  if [[ -f $bootstrap_script ]]; then
    tmux send-keys -t "$session_name" "$bootstrap_script" Enter
  fi
}
export -f _gw-run-bootstrap-script

gw-new() {
  if [[ -z "$1" ]]; then
    echo "Usage: gw-new <branch> [bootstrap script]" >&2
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
      && _gw-run-bootstrap-script "$session_name" "$2";
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


# Manage git worktrees with fzf: list, switch (with tmux session), delete.
# Run from inside a git repo. Delegates to the gw-* functions for worktree/tmux operations.
open-worktree() (
  set -e

  REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not in a git repo." >&2; exit 1; }
  cd "$REPO_ROOT"
  CURRENT_REF=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

  FZF_TMUX_OPTS="-d20 --reverse"
  FZF_PREVIEW_WINDOW="right:60%"

  FZF_KEY_SWITCH="enter"
  FZF_KEY_DELETE="ctrl-x"
  FZF_KEY_GOBACK="esc"
  FZF_KEY_YOINK="ctrl-y"

  branch_from_line() {
    echo "$1" | awk '{print $NF}' | tr -d '[]'
  }

  select_worktree_with_fzf() {
    local worktree_lines=$1
    echo "$worktree_lines" | fzf $FZF_TMUX_OPTS \
      --prompt "Select worktree: " \
      --preview "git -C \"$REPO_ROOT\" -c color.ui=always diff --color=always \"$CURRENT_REF..\$(echo {} | awk '{print \$NF}' | tr -d '[]')\" 2>/dev/null || echo '(same as $CURRENT_REF)'" \
      --preview-window="$FZF_PREVIEW_WINDOW" \
      --bind "${FZF_KEY_DELETE}:execute(open-worktree --delete {})+reload(git worktree list)" \
      --bind "${FZF_KEY_YOINK}:execute(open-worktree --yoink {})+abort" \
      --footer "${FZF_KEY_SWITCH}: switch | ${FZF_KEY_DELETE}: delete | ${FZF_KEY_YOINK}: copy path"
  }

  if [[ "${1:-}" == "--delete" ]]; then
    shift
    branch=$(branch_from_line "$*")
    gw-delete "$branch"
    exit 0
  fi

  if [[ "${1:-}" == "--yoink" ]]; then
    shift
    branch=$(branch_from_line "$*")
    gw-yoink "$branch"
    exit 0
  fi

  worktree_lines=$(git worktree list)
  selected=$(select_worktree_with_fzf "$worktree_lines")
  [[ -z "$selected" ]] && exit 0
  branch=$(branch_from_line "$selected")
  gw-switch "$branch"
)
export -f open-worktree
