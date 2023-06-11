# `.dotfiles`

## Steps for setting up MacOS

1. Clone repository in `$HOME`

2. Export existing .files to dotfiles directory

3. Install Brew, oh-my-zsh (with plugins/themes) if not available

4. Create symlinks for all `.config` files using stow

## Setup

1. Export current configurations to dotfiles directory

    ```bash
    make export
    ```

2. Install homebrew, oh-my-zsh (with plugins/themes) and VIM theme

    ```bash
    make install
    ```

3. Creating Symlinks to home directory from dotfiles git

    ```bash
    make link
    ```

## [Hammerspoon](https://www.hammerspoon.org/)

Hammerspoon is a desktop automation tool for macOS. It bridges various system level APIs into a Lua scripting engine, allowing you to have powerful effects on your system by writing Lua scripts.

## Resources

- [Using GNU Stow to manage your dotfiles](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
- <https://dotfiles.github.io/>
- [Apple Developer Documentation](https://developer.apple.com/documentation/devicemanagement)
- [MacOS defaults](https://macos-defaults.com/)
