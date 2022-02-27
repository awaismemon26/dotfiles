#!/usr/bin/env zsh


# If you get a error in this script, stop executing the script instantly while having non-zero status
set -e

# Displaying line number of error message
trap 'Error $LINENOE' ERR

DOTDIR="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
    pwd -P
)"

source "${DOTDIR}"/utils/*.zsh

green "Dotfiles path: ${DOTDIR}"

magenta "zsh"
(
    set -x                              # It is like verbose, this will show more details on operations performed with the following commands
    cp ~/.zshrc "${DOTDIR}"/zsh
    cp ~/.p10k.zsh "${DOTDIR}"/zsh
    cp ~/.functions "${DOTDIR}"/zsh
    cp ~/.aliases "${DOTDIR}"/zsh

)

magenta "Vim"
(
    set -x
    cp ~/.vimrc "${DOTDIR}"/vim
    cp -r ~/.vim "${DOTDIR}"/vim
)

magenta "Git"
(
    set -x
    cp ~/.gitconfig "${DOTDIR}"/git

)

magenta "Brewfile dump"
(
    set -x
    brew bundle dump --describe -f --file="${DOTDIR}"/Brewfile    
)

magenta "Brew casks and formulae"
(
    set -x
    brew list --cask > "${DOTDIR}"/brew/casks.txt
    brew list --formulae > "${DOTDIR}"/brew/formulae.txt

)

green "git status"
(
    set -x
    git -C "${DOTDIR}" status
)

green "git diff"
(
    set -x
    git -C "${DOTDIR}" --no-pager diff
)
