
#####################################################################################################
#                               ZSH Configuration - Powerlevel10k
#####################################################################################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER=$(whoami)

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# PLUGINS USAGE
# sudo -- press ESC key double times and you will recieve the last command that you run with sudo 
# copypath -- copy complete path to clipboard
# copyfile -- copy contents of a file to clipboard
# copybuffer - control + o will copy current command on terminal to your clipboard
# dirhistory -- you can navigate directories by pressing 
plugins=(git virtualenv zsh-autosuggestions zsh-syntax-highlighting kubectl sudo copypath copyfile copybuffer dirhistory)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(virtualenv status background_jobs)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Auto Complete 
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#####################################################################################################
#                                           GOOGLE CLOUD SDK
#####################################################################################################
# The next line updates PATH for the Google Cloud SDK.
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
# The next lines enables bash completion in Zsh for gcloud. 
autoload -U compinit compdef
compinit
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export CLOUDSDK_PYTHON_SITEPACKAGES=1



#####################################################################################################
#                                           PYENV CONFIGURATION
#####################################################################################################

export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
# export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"

# Remove cleanup right after installing packages
export HOMEBREW_NO_INSTALL_CLEANUP=1

export PATH="/usr/local/sbin:$PATH"

#####################################################################################################
#                                                 FUNCTIONS
#####################################################################################################

source ~/.functions


#####################################################################################################
#                                                  ALIASES
#####################################################################################################

source ~/.aliases


#####################################################################################################
#                                                   OPENSSL
#####################################################################################################
# # openssl@3 is keg-only, which means it was not symlinked into /opt/homebrew, because macOS provides LibreSSL.
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH" # need to have openssl@3 first in your PATH
# # For compilers to find openssl@3 you may need to set
# export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"

# # For pkg-config to find openssl@3 you may need to set
# export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"



#####################################################################################################
#                                                   JAVA
#####################################################################################################

# export JAVA_17_HOME=$(/usr/libexec/java_home)
# export JAVA_8_HOME=$(/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/contents/home)

# alias java8='export JAVA_HOME=$JAVA_8_HOME'
# alias java17='export JAVA_HOME=$JAVA_17_HOME'

# Java 17.0.12 is already symlinked with /Library/Java/JavaVirtualMachines/openjdk.jdk
# You can also export openjdk 11 path to use it

#export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
#export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
# -------
#  /usr/local/Cellar/openjdk@11/11.0.12/libexec/openjdk.jdk/Contents/Home
# sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
# sudo ln -sn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

source $ZSH/oh-my-zsh.sh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# export DOTNET_ROOT="/usr/local/opt/dotnet/libexec"

#####################################################################################################
#                                                  KUBECTL PLUGIN (KREW)
# export PATH="${PATH}:${HOME}/.krew/bin"

export GPG_TTY=$(tty)

# ########################################## LINKERD #############################################
# export PATH=$PATH:/Users/awaismemon/.linkerd2/bin

# # To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
# [[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh
