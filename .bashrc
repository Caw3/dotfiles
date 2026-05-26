#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Functions
vimgrep() {
  HELP="Usage: vimgrep {pattern} [files...]"
  [[ $# -lt 1 ]] && echo "$HELP" && return 1

  PATTERN=$1
  shift

  if [[ $# -eq 0 ]]; then
    if git rev-parse --is-inside-work-tree &>/dev/null; then
      mapfile -t FILES < <(git ls-files)
    else
      mapfile -t FILES < <(find . -type f)
    fi
  else
    FILES=("$@")
  fi

  if command -v rg >/dev/null 2>&1; then
    GREP_CMD=(rg --vimgrep "$PATTERN" "${FILES[@]}")
  else
    GREP_CMD=(grep -Hin "$PATTERN" "${FILES[@]}")
  fi
  tmpfile=$(mktemp)
  ${GREP_CMD[@]} > $tmpfile
  "$EDITOR" -q $tmpfile
}
export -f vimgrep

vifzf() {
  if command -v fd >/dev/null 2>&1; then
    FD_CMD=(fd)
  else
    FD_CMD=(find)
  fi
  "${FD_CMD[@]}" | fzf --multi --bind="enter:become($EDITOR {})" --preview='cat {}'
}
export -f vifzf

gw-new() {
  local branch="$1"
  local repo_root=$(basename $(git rev-parse --show-toplevel 2>/dev/null)) 
  local path="$HOME/repos/${repo_root//./}-worktree-${branch//./}"
  local session_name="${repo_root//./} (${branch//./})"

  if tmux has-session -t "$session_name" 2> /dev/null; then
     tmux switch-client -t "$session_name";
  else
    git worktree add "$path" "$branch" \
      && tmux new-session -c "$path" -s "$session_name" -d \
      && tmux switch-client -t "$session_name";
  fi
}
export -f gw-new

gw-switch() {
  local branch="$1"
  local repo_root=$(basename $(git rev-parse --show-toplevel 2>/dev/null)) 
  local session_name="${repo_root//./} (${branch//./})"
  local path="$(git worktree list | grep -F "[$branch]" | cut -d' ' -f1)"

  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not in a git repo." >&2; exit 1; }
  local primary_worktree=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print $2; exit}' || echo "$REPO_ROOT")

  if ! [[ -d "$path" ]]; then
    echo "No worktree at $path — run gw-new $branch first" >&2
    return 1
  fi

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

## Prompt
export PS1='\[\e[32m\]\u@\h\[\e[0m\] \[\e[34m\]\W\[\e[0m\] '
export PROMPT_COMMAND='history -a'

## SHOPT
shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s globstar
shopt -s extglob
shopt -s histappend
shopt -s expand_aliases
shopt -s checkwinsize

set -o vi

## Exports
export EDITOR='nvim'
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreredups:erasedups
export MANROFFOPT="-c"
export MANPAGER="nvim +Man!"

## Aliases
alias vi="$EDITOR"
alias vim="$EDITOR"
alias ll='ls --color -lah'
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

alias gd='git diff'
alias gb='git branch'
alias gbl='git branch -vva --sort=-committerdate'
alias gs='git status -s'
alias gw='git worktree'
alias gl='git log --oneline --graph --abbrev-commit'
alias gc='git checkout'

alias ta="tmux a"
alias tm="tmux"
alias ca="cursor-agent"

## FZF
OPTIONS=" --preview='cat {}' --preview-window=hidden "
BINDS="\
--bind '?:toggle-preview' \
--bind 'tab:toggle+up' \
--bind 'shift-tab:toggle+down' \
--bind 'ctrl-d:preview-half-page-down' \
--bind 'ctrl-u:preview-half-page-up'"

COLORS=" --color='\
bg:-1,\
bg+:-1,\
fg:white,\
fg+:white,\
info:magenta,\
marker:magenta,\
pointer:blue,\
header:blue,\
spinner:magenta,\
hl:cyan,\
hl+:cyan,\
prompt:bright-black'"
 
export FZF_DEFAULT_OPTS=$OPTIONS$BINDS$COLORS
export FZF_DEFAULT_COMMAND='rg -L --files --hidden -g "!.git" -g "!node_modules" || find .'
export FZF_TMUX_OPTS="-p -w 80% -h 80%"
