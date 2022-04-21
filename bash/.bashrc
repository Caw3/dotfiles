#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Prompt
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty)) /"
}

export PS1='\e[32m\u@\h\e[0m \e[34m\w\e[0m $(parse_git_branch)'

## HIST
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.cache/.bash_history

### SHOPT
shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s globstar
shopt -s extglob
shopt -s histappend
shopt -s expand_aliases
shopt -s checkwinsize
bind "set completion-ignore-case on"
set -o vi

# Exports
export BASHDIR=$HOME/.config/bash
export TERMINAL='alacritty'
export MANPAGER='nvim +Man!'
export EDITOR='nvim'
export BROWSER='qutebrowser'

# Aliases

alias nv=nvim
alias py=python3
alias grep='grep --color=auto'
alias ls='ls --color'
alias la='ls -a'
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'
alias psmem='ps auxf | sort -nr -k 4 | head -5'
alias pscpu='ps auxf | sort -nr -k 3 | head -5'
alias gP='git push'
alias gp='git pull'
alias gs='git status -s'
alias gl='git log --oneline --graph --abbrev-commit'
alias battery='cat /sys/class/power_supply/BAT0/capacity'
alias pm="pulsemixer"
alias ta="tmux a"
alias tm="tmux"
alias lf="clear;lf"

# Bindings
bind "\C-e":edit-and-execute-command

# FZF
[[ -f /usr/share/fzf/completion.bash ]] && . /usr/share/fzf/completion.bash
[[ -f /usr/share/fzf/key-bindings.bash ]] && . /usr/share/fzf/key-bindings.bash
