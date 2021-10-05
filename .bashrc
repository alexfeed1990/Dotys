#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#Aliases
alias nvi='nvim'
alias nv='nvim'

# Path variables

echo "PATH=$PATH:~/.config/rofi/bin" >> ~/.profile
