#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Functions
vimtag() {
  TAGS="./tags"
  [[ -f "$TAGS" ]] || return 1
  TAG=$(grep -v ^\! $TAGS | cut -f 1,2,3 | column -t -s $'\t' | fzf | awk '{print $1}')
  $EDITOR -t "$TAG"
}
export -f vimtag

vimgrep() {
  HELP="Usage: vimgrep {pattern} {files}..."
  PATTERN=$1
  [[ $# -lt 1 ]] && echo "$HELP" && return 1
  [[ $# -gt 1 ]] && shift && $EDITOR -c "silent Grep $PATTERN $*" && return 0
  $EDITOR -c "silent Grep $PATTERN" && return 0
}
export -f vimgrep

cht() {
  curl -s cht.sh/"$1" | less -R
}
export -f cht

gbf() {
    git switch $(git reflog | grep -o 'checkout: moving from [^ ]* to [^ ]*' | awk '{print $NF}' | awk '!seen[$0]++' | fzf-tmux --preview='git log {} --decorate --graph --color=always')
}
export -f gbf

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
export EDITOR='nvim'
export HISTSIZE= 
export HISTFILESIZE=
export HISTCONTROL=erasedups

## Aliases
alias vi="nvim"
alias vim="nvim"
alias py='python3'
alias la='ls -a'
alias ll='ls --color -lah'
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

## FZF
OPTIONS=" --preview='bat --color=always --style=numbers --line-range=:500 {} || cat {}' --preview-window=hidden "
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
export BAT_THEME='Nord'

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

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/cararo/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
