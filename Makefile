.PHONY: Export local config files to dotfiles git repo
.SILENT: export
export: 
	./export-config.zsh
	

.PHONY: Import config dotfiles from git and place it in home directory
.SILENT: link


.PHONY: Installing Xcode and Homebrew
.SILENT: init
init: 
	./bootstrap.zsh

.PHONY: Creating Symlinks 
.SILENT: symlinks
symlinks:
	./symlinks.zsh
