#!/usr/bin/env zsh
# Setup script for setting up a new MAC OS machine

# If you get a error in this script, stop executing the script instantly while having non-zero status
set -e

DOTDIR="$(
      cd ~/.dotfiles "$(dirname "$0")" >/dev/null 2>&1 || exit
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
    set -x
    if test ! $(which brew); then
        echo "Homebrew not present, downloading and installing..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
)
magenta "Update HomeBrew"
(
    set -x
    brew update
)
magenta "Installing Homebrew bundle using brewfile"
(
    set -x

    read -p "Would you like to install all brew packages ? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    brew bundle install --file=${DOTDIR}/Brewfile
)
magenta "Installing ZSH Autosuggestion Plugin"
(
    set -x
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

)


