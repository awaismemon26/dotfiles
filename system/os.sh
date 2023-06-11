## The preference you wish to set is saved in ~/Library/Preferences/ByHost, so you have to add the switch -currentHost to the defaults command

#################### GENERAL 

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable “natural” (Lion-style) scrolling
defaults write -g com.apple.swipescrolldirection -bool false 

# Increase sound quality for Bluetooth headphones/headsets
# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -setusingnetworktime on # turn on 
sudo systemsetup -settimezone "Europe/Berlin" > /dev/null

#################### ENERGY SAVING -- Power Management Settings
# Enable lid wakeup
sudo pmset -a lidwake 1

# Sleep the display after 15 minutes
sudo pmset -a displaysleep 15

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Set machine sleep to 30 minutes on battery
sudo pmset -b sleep 30

# Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
sudo rm /private/var/vm/sleepimage

# Create a zero-byte file instead…
sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
sudo chflags uchg /private/var/vm/sleepimage

###################### SCREEN

# Do not require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 60
defaults write com.apple.screensaver askForPasswordDelay -int 120

##################### SCREENSHOTS

# Include date and time in screenshot filenames e.g Screenshot 2020-01-09 at 13.27.20.png
defaults write com.apple.screencapture "include-date" -bool "true" 

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"


##################### FINDER

# Show hidden files in finder
defaults write com.apple.Finder AppleShowAllFiles -bool NO 

# Finder: hide all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool false

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder "ShowPathbar" -bool "true"

# When performing a search, search the current folder by default
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Default List view style
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

####################### DOCK

# Dock size
defaults write com.apple.dock "tilesize" -int "45" 

# Change minimize/maximize window effect
defaults write com.apple.dock "mineffect" -string "scale" 

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

####################### TIME MACHINE
# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "false"

#################### MESSAGES
# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

cp -Rp ~/Library/Services ~/.dotfiles/system/Library/ # automator stuff
cp -Rp ~/Library/Fonts ~/.dotfiles/system/Library/ # all those fonts you've installed

# Copy the file to specified location and restart dock by `killall Dock`
cp -Rp ~/Library/Preferences/com.apple.dock.plist ~/.dotfiles/system/Library

#################### Restart to see change effect
killall Finder
killall Dock