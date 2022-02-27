#!/usr/bin/env bash
# Setup script for setting up a new MAC OS machine


DOTDIR="$(
      cd ~/.dotfiles "$(dirname "$0")" >/dev/null 2>&1 || exit
      pwd -P
)"

BREWFILE=($DOTDIR)/brew/

echo "Starting Setup"


# Agree with Xcode License
echo "Xcode license.."
sudo xcodebuild -license

# install xcode CLI
echo "Installing Xcode Cli..."
xcode-select —-install

echo "Installing Homebrew..."
# Check for Homebrew to be present, install if it's missing
if test ! $(which brew); then
    echo "Homebrew not present, downloading and installing..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


# Update homebrew recipes
brew update

PACKAGES=(
    git
    tmux
    bat
    macvim
    mysql
    fzf
    ctags
<...list all the packages you want to install>
    readline
)
echo "Installing packages..."
brew install ${PACKAGES[@]}
# any additional steps you want to add here

echo "Installing cask..."
CASKS=(
    iterm2
    adobe-acrobat-reader
    skype
    slack
    spotify
    intellij-idea-ce
    visual-studio-code
    steam
    evernote
    1password
    macdown
)
echo "Installing cask apps..."
brew cask install ${CASKS[@]}
