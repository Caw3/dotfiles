#!/bin/sh

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.cache/.zsh_history
setopt appendhistory

# Misc
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
unsetopt BEEP

#Load files
source "$ZDOTDIR/zsh-utils"

# auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

#Load Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

zsh_add_file  "zsh-aliases"
zsh_add_file  "zsh-vi"

#Key bindings
bindkey '^ ' autosuggest-accept
bindkey '^n' down-history 
bindkey '^p' up-history 

#Cosmetic
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
# This line obtains information from the vcs.
zstyle ':vcs_info:git*' formats "%F{white}(%F{green}%b%F{white}) "
precmd() { vcs_info }

# Enable substitution in the prompt.
setopt prompt_subst

PROMPT="%B[%b%B%F{green}%n%f%b%B%F{green}@%f%F{green}%m%f%F{blue}%~%f]%b "
PROMPT+='${vcs_info_msg_0_}'

