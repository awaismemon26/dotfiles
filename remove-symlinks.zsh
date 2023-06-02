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

green "Removing Symlinks -> Dotfiles: ${DOTDIR} -> ~/"

magenta "ZSH config files"
(
    # More details on operations performed
    set -x                              
    stow -D zsh
)

magenta "Git config files"
(
    set -x
    stow -D git
)

magenta "Vim config files"
(
    set -x
    stow -D vim
)
magenta "VSCode config files"
(
    set -x
    # stow -D vscode 
    unlink "$HOME/Library/Application Support/Code/User/settings.json"
)
