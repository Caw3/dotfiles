#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Functions
vimtag() {
  TAGS="./tags"
  QUERY=$1
  if [[ -z "$QUERY" ]]; then
      FZF_CMD="fzf"
  else
      FZF_CMD="fzf -q $QUERY"
  fi
  ctags --tag-relative $(git ls-files)
  TAG=$(grep -v ^\! $TAGS | cut -f 1,2,3 | column -t -s $'\t' | $FZF_CMD | awk '{print $1}')
  $EDITOR -t "$TAG"
}
export -f vimtag

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


cht() {
  curl -s cht.sh/"$1" | less -R
}
export -f cht

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

vterm_printf() {
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}
