#!/usr/bin/env zsh

if test ! "$(uname)" = "Darwin"
  then
  exit 0
fi

# Install all appropiate updates
echo "› sudo softwareupdate -i -a"
sudo softwareupdate -i -a
sudo softwareupdate --install-rosetta --agree-to-license # Install Rosetta 