# `.dotfiles`

## Steps for setting up MacOS

1. Install XCode Tools

2. Install Brew, if not available

3. Update Brew

4. Install Brew packages using Brewfile

5. Create symlinks for all `.config` files using stow

## Setup

1. Export current configurations

    ```bash
    make export
    ```

2. Install homebrew

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

`
