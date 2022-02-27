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
    set -x
    cp ~/.zshrc "${DOTDIR}"/zsh

)
