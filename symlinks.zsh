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

green "Creating Symlinks -> Dotfiles: ${DOTDIR} -> ~/"

magenta "ZSH config files"
(
    set -x                              
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
)
magenta "Vim config files"
(
    set -x
    stow vim --adopt
)
magenta "SSH config"
(
    set -x
    stow ssh --adopt
)
magenta "VSCode config files"
(
    set -x
    stow vscode --adopt
    ln -sf "$DOTDIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
)
