.PHONY: Export local config files to dotfiles git repo
.SILENT: export
export: 
	./export-config.zsh


.PHONY: Installing Xcode and Homebrew
.SILENT: init
init: 
	./bootstrap.zsh

.PHONY: Creating Symlinks to home directory from dotfiles git
.SILENT: link
link:
	./symlinks.zsh

.PHONY: Removing Symlinks
.SILENT: unlink
unlink: 
	./remove-symlinks.zsh