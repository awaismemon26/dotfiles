#!/usr/bin/env zsh
# Setup script for setting up a new MAC OS machine

# If you get a error in this script, stop executing the script instantly while having non-zero status
set -e

DOTDIR="$(
      cd ~/dotfiles "$(dirname "$0")" >/dev/null 2>&1 || exit
      pwd -P
)"

source "${DOTDIR}"/utils/*.zsh

green "Dotfile path: ${DOTDIR}"

# Agree with Xcode License

#magenta "Agreeing Xcode License"
#(
#    set -x 
#    sudo xcodebuild -license
#)

#magenta "Installing XCode CLI"
#(
#    set -x
#    xcode-select —-install
#)

magenta "Installing Homebrew"
(
    if test ! $(which brew); then
        echo "Homebrew not present, downloading and installing..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
)

magenta "Update HomeBrew"
(
    read  "?Would you like to update brew ? (Y/N):? " confirm
    if [[ $confirm == "y" ]]; then
        brew update
    else
       echo "Brew update skipped" 
    fi
)

magenta "Installing Homebrew bundle using brewfile"
(
    read "?Would you like to install all brew packages ? (Y/N):?" confirm 
    if [[ $confirm == [yY] ]]; then
        brew bundle install --file=${DOTDIR}/Brewfile; 
    else 
        echo "Brew package installation skipped"
    fi
)

magenta "Installing ZSH Autosuggestion Plugin"
(
    set -x
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

)

magenta "Installing ZSH Syntax Highlighting Plugin"
(
    set -x
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
)
