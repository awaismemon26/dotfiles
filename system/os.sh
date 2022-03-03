# Show hidden files in finder
defaults write com.apple.finder AppleShowAllFiles YES

cp -Rp ~/Library/Services ~/.dotfiles/system/Library/ # automator stuff
cp -Rp ~/Library/Fonts ~/.dotfiles/system/Library/ # all those fonts you've installed

# Copy the file to specified location and restart dock by `killall Dock`
cp -Rp ~/Library/Preferences/com.apple.dock.plist ~/.dotfiles/system/Library
