#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#Aliases

alias nano='nvim'
alias pacup='sudo pacman -Syu'
alias pacupdate='sudo pacman -Syu'
alias vi='nvim'
alias vim='nvim'
alias lvim='nvim'
alias nvi='nvim'
alias nv='nvim'

# Path variables

echo "PATH=$PATH:~/.config/rofi/bin" >> ~/.profile
