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
    if ! command -v brew &> /dev/null; then
	echo "Homebrew not present, downloading and installing..."
	export HOMEBREW_NO_INSTALL_FROM_API=1 && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)" >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew already present, skipping installation"
    fi
)

magenta "Updating and cleaning up HomeBrew"
(
    read  "?Would you like to update and clean brew ? (Y/N):? " confirm
    if [[ $confirm == "y" ]]; then
        brew update --ignore-pinned && brew cleanup && brew doctor # ignore pinned formulas -- brew list --pinned
    else
       echo "Update and cleanup skipped" 
    fi
)

magenta "Installing Homebrew bundle using brewfile"
(
    read "?Would you like to install all brew packages ? (Y/N):?" confirm 
    if [[ $confirm == [yY] ]]; then
        brew bundle install --file=${DOTDIR}/brew/Brewfile; 
    else 
        echo "Brew package installation skipped"
    fi
)

magenta "Installing Oh My ZSH"
(
    if [ -d ~/.oh-my-zsh ]; then
        echo "Oh My ZSH already present, skipping installation..."
    else
        echo "Oh My ZSH not present, downloading and installing..."
        export RUNZSH="no" && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
)

magenta "Installing ZSH Autosuggestion Plugin"
(
    
    read "?Would you like to install zsh autosuggestion plugin? (Y/N):?" confirm 
    if [[ $confirm == [yY] ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
        echo "ZSH Autosuggestion plugin installation skipped"
    fi

)

magenta "Installing ZSH Syntax Highlighting Plugin"
(
    read "?Would you like to install zsh syntax highlighter plugin ? (Y/N):?" confirm 
    if [[ $confirm == [yY] ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo "ZSH Syntax Highlighter Plugin installation skipped"
    fi
)

magenta "Installing ZSH PowerLevel10k Theme"
(
    read "?Would you like to install zsh powerlevel10k theme? (Y/N):?" confirm 
    if [[ $confirm == [yY] ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    else
        echo "ZSH PowerLevel10k Theme installation skipped"
    fi
)

magenta "Initializing VIM Setup"
(
    read "?Would you like to install Color themes for VIM? (Y/N):?" confirm 
    if [[ $confirm == [yY] ]]; then
        sh -c "$(curl -o ${VIM_COLORS:-$HOME/.vim/colors}/PaperColor.vim https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim)"
        sh -c "$(curl -o ${VIM_COLORS:-$HOME/.vim/colors}/monokai.vim https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim)"
        sh -c "$(curl -o ${VIM_COLORS:-$HOME/.vim/colors}/molokai.vim https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim)"
    else
        echo "VIM Color Theme installation skipped"
    fi

    read "?Would you like to install Plugins for VIM? (Y/N):?" confirm 
    if [[ $confirm == [yY] ]]; then
        sh -c "$(curl -o ${VIM_AUTOLOAD:-$HOME/.vim/autoload}/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim)"
    else
        echo "VIM Plugin installation skipped"
    fi
)
