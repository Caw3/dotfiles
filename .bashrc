#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Functions
vimgrep() {
  HELP="Usage: vimgrep {pattern} {files}..."
  PATTERN=$1
  [[ $# -lt 1 ]] && echo "$HELP" && return 1

  git status &>/dev/null && [[ $# -eq 1 ]] &&
    vim -c "silent Grep $PATTERN" && return 0

  [[ $# -gt 1 ]] && shift && vim -c "silent vimgrep /$PATTERN/g $*" && return 0
}
export -f vimgrep

cht() {
  curl -s cht.sh/"$1" | less -R
}
export -f cht

## Prompt
export PS1='\[\e[32m\]\u@\h\[\e[0m\] \[\e[34m\]\W\[\e[0m\] '

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
export EDITOR='vi'
export MANPAGER="vim -M +MANPAGER -"

export HISTSIZE= 
export HISTFILESIZE=
export HISTCONTROL=erasedups

## Aliases
alias py='python3'
alias la='ls -a'
alias ll='ls -l'
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

alias gd='git diff'
alias gc='git checkout'
alias gb='git branch'
alias gbl='git branch -vva --sort=-committerdate'
alias gP='git push'
alias gp='git pull'
alias gs='git status -s'
alias gw='git worktree'
alias gl='git log --oneline --graph --abbrev-commit'
alias gcp='git commit -p'

alias battery='cat /sys/class/power_supply/BAT0/capacity'
alias ta="tmux a"
alias tm="tmux"
alias emacs="emacsclient"

## FZF
OPTIONS=" --preview='bat --color=always --style=numbers --line-range=:500 {} || cat {}' --preview-window=hidden "
BINDS="\
--bind '?:toggle-preview' \
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
export BAT_THEME='Nord'
. "$HOME/.cargo/env"

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
