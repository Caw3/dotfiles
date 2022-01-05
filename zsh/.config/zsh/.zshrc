#!/bin/sh
export ZDOTDIR=$HOME/.config/zsh
HISTFILE=~/.zsh_history
setopt appendhistory

# Misc
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
unsetopt BEEP


# Remap caps to escape
setxkbmap -option caps:escape
# Set Zathura to default app
xdg-mime default org.pwnt.zathura.desktop application/pdf

#Load files
source "$ZDOTDIR/zsh-utils"
zsh_add_file  "zsh-exports"
zsh_add_file  "zsh-aliases"
zsh_add_file  "zsh-vi"


#Load Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

#Key bindings
bindkey '^ ' autosuggest-accept

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

