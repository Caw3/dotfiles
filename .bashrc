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
  tmpfile=$(mktemp)
  rg --vimgrep "$PATTERN" "$@" > "$tmpfile"
  "$EDITOR" -q "$tmpfile"
}
export -f vimgrep

_vimgrep() {
  if [[ $COMP_CWORD -ge 2 ]]; then
    COMPREPLY=($(compgen -f -- "${COMP_WORDS[COMP_CWORD]}"))
  fi
}
complete -F _vimgrep vimgrep

vifzf() {
  if command -v fd >/dev/null 2>&1; then
    FD_CMD=(fd)
  else
    FD_CMD=(find)
  fi
  "${FD_CMD[@]}" | fzf --multi --bind="enter:become($EDITOR {})" --preview='cat {}'
}
export -f vifzf


_gw-primary-worktree() {
  git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print $2; exit}'
}

_gw-branch-to-session() {
  local branch="$1"
  local primary_worktree=$(_gw-primary-worktree)
  local session_name="$(basename $primary_worktree)-worktree-${branch}"
  session_name=${session_name//\//__}
  session_name=${session_name//.//}
  echo $session_name
}

_gw-worktree-path() {
  local branch="$1"
  local primary_worktree=$(_gw-primary-worktree)
  echo "${primary_worktree}-worktree-${branch}"
}

gw-new() {
  if [[ -z "$1" ]]; then
    echo "Usage: gw-new <branch>" >&2
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
      && tmux switch-client -t "$session_name";
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
_gw() { COMP_WORDS=(git worktree "${COMP_WORDS[@]:1}"); ((COMP_CWORD++)); __git_wrap__git_main; }
complete -o default -o nospace -F _gw gw
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
export PATH=/opt/spotify-devex/bin:$PATH
