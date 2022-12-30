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
    vim -c "silent vimgrep /$PATTERN/g \`git ls-files\`" && return 0

  [[ $# -eq 1 ]] && vim -c "silent vimgrep /$PATTERN/g  \`find .\`" && return 0
  [[ $# -gt 1 ]] && shift && vim -c "silent vimgrep /$PATTERN/g $*" && return 0
}
export -f vimgrep

cht() {
  curl -s cht.sh/"$1" | less -R
}
export -f cht

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
alias gP='git push'
alias gp='git pull'
alias gs='git status -s'
alias gl='git log --oneline --graph --abbrev-commit'

alias battery='cat /sys/class/power_supply/BAT0/capacity'
alias ta="tmux a"
alias tm="tmux"
alias emacs="emacsclient -c -a 'emacs'" 
