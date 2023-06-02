#!/usr/bin/env zsh


# If you get an error in this script, stop executing the script instantly while having non-zero status
set -e

# Displaying line number of error message
trap 'Error $LINENOE' ERR

DOTDIR="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
    pwd -P
)"

source "${DOTDIR}"/utils/*.zsh

green_title "Dotfiles path: ${DOTDIR}"

magenta_title "zsh"
(
    files=("$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.aliases")
    for file in "${files[@]}"; do
        # Check if a symbolic link already exists
        filename=$(basename "${file}")
        if [[ -L "$HOME/$filename" ]]; then
            echo "Symbolic link already exists for ${file}"
        else
            cp "$HOME/$filename" "${DOTDIR}/zsh"
            echo "Copied ${file}"
        fi
    done
)

magenta_title "Vim"
(
    files=("$HOME/.vimrc" "$HOME/.vim")
    for file in "${files[@]}"; do
        # Check if a symbolic link already exists
        filename=$(basename "${file}")
        if [[ -L "$HOME/$filename" || -d "$HOME/$filename" ]]; then
            echo "Symbolic link already exists for ${file}"
        else
            cp "$HOME/$filename" "${DOTDIR}/vim"
            echo "Copied ${file}"
        fi
    done
)

magenta_title "Git"
(
    files=("$HOME/.gitconfig")
    for file in "${files[@]}"; do
        # Check if a symbolic link already exists
        filename=$(basename "${file}")
        if [[ -L "$HOME/$filename" ]]; then
            echo "Symbolic link already exists for ${file}"
        else
            cp "$HOME/$filename" "${DOTDIR}/git"
            echo "Copied ${file}"
        fi
    done

)

magenta_title "vscode"
(   
    # Check if a symbolic link already exists
    if [[ -L "$HOME/Library/Application Support/Code/User/settings.json" ]]; then
        echo "Symbolic link already exists for vscode settings.json"
    else
        cp "$HOME/Library/Application Support/Code/User/settings.json" "${DOTDIR}/vscode"
        echo "Copied vscode settings.json"
    fi
)

magenta_title "ssh"
(
    read "?Would you like to export SSH config file? (Y/N):?" confirm 
    if [[ $confirm == [yY] ]]; then
        if [[ -L "$HOME/.ssh/config" ]]; then
            echo "Symbolic link already exists for SSH config"
        else
            cp "$HOME/.ssh/config" "${DOTDIR}/ssh"
            echo "Copied SSH config"
        fi
    else
        echo "SSH config export skipped"
    fi
)

magenta_title "Brewfile dump"
(
    set -x
    brew bundle dump --describe -f --file="${DOTDIR}"/brew/Brewfile    
)

magenta_title "Brew casks and formulae"
(
    set -x
    brew list --cask > "${DOTDIR}"/brew/casks.txt
    brew list --formulae > "${DOTDIR}"/brew/formulae.txt

)

green_title "git status"
(
    set -x
    git -C "${DOTDIR}" status
)

green_title "git diff"
(
    set -x
    git -C "${DOTDIR}" --no-pager diff
)