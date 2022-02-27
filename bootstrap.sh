#!/usr/bin/env bash
# Setup script for setting up a new MAC OS machine


DOTDIR="$(
      cd ~/.dotfiles "$(dirname "$0")" >/dev/null 2>&1 || exit
      pwd -P
)"

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


echo "Installing Brew bundle using Brewfile..."
brew bundle install --file=${DOTDIR}/Brewfile

