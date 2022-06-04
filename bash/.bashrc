#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Prompt
parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}
parse_git_branch() {
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
export VISUAL='vim'
export EDITOR='vim'
export MANPAGER="vim -M +MANPAGER -"
export TERMINAL='alacritty'
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
alias emacs="emacsclient -c -a 'emacs'" 

# FZF
OPTIONS="--reverse --preview='cat {}' --preview-window=hidden "

BINDS="\
--bind '?:toggle-preview' \
--bind 'ctrl-d:preview-half-page-down' \
--bind 'ctrl-u:preview-half-page-up' \
--bind 'ctrl-a:select-all'"

COLORS=" --color='\
bg:-1,\
bg+:-1,\
fg:white,\
fg+:white,\
info:magenta,\
marker:magenta,\
pointer:blue,\
header:magenta,\
spinner:magenta,\
hl:cyan,\
hl+:cyan,\
prompt:bright-black'"

export FZF_DEFAULT_OPTS=$OPTIONS$BINDS$COLORS
command -v rg > /dev/null && \
export FZF_DEFAULT_COMMAND='rg -L --files --hidden -g "!.git" -g "!node_modules"'


[[ -f /usr/share/fzf/completion.bash ]] && . /usr/share/fzf/completion.bash
[[ -f /usr/share/fzf/key-bindings.bash ]] && . /usr/share/fzf/key-bindings.bash
