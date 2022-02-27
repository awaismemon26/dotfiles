#!/usr/bin/env zsh

# This file will be importing the following configurations from 


# If you get a error in this script, stop executing the script instantly while having non-zero status
set -e

# Displaying line number of error message
trap 'Error $LINENOE' ERR

DOTDIR="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
    pwd -P
)"

source "${DOTDIR}"/utils/*.zsh

green "Creating Symlinks -> Dotfiles: ${DOTDIR} -> ~/"

magenta "ZSH config files"
(
    set -x                              # It is like verbose, this will show more details on operations performed with the following commands
    stow zsh --adopt 
#    ln -sf "${DOTDIR}"/zsh/.zshrc ~/.zshrc
#    ln -sf "${DOTDIR}"/zsh/.p10k.zsh ~/.p10k.zsh
#    ln -sf "${DOTDIR}"/zsh/.functions ~/.functions
#    ln -sf "${DOTDIR}"/zsh/.aliases ~/.aliases

)

magenta "Git config files"
(

    set -x
    stow git --adopt
    #ln -sf "${DOTDIR}"/git/.gitconfig ~/.gitconfig
)

magenta "Vim config files"
(
    set -x
    stow vim --adopt
    #ln -sf "${DOTDIR}"/vim/.vimrc ~/.vimrc
    #stow
#    ln -sf "${DOTDIR}"/vim/.vim/autoload/plug.vim ~/.vim/autoload/plug.vim
#    ln -sf "${DOTDIR}"/vim/.vim/autoload/plug.vim ~/.vim/autoload/plug.vim

)
