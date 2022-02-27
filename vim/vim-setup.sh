# Create directory in ~/.vim/colors 

All the settings of VIM are defined in ~/.vimrc file.


Following configuration is required for setting up colorschemes in Vim

I have installed 3 themes 

1. PaperColor
2. Molokai
3. Monokai

To install this theme, we have to download the vim file from their respective github accounts

Following are the link to their github vim file

1. curl -o PaperColor.vim https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim
2. curl -o monokai.vim https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim
3. curl -o molokai.vim https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim

After downloading the files, we have to add the following lines in ~/.vimrc file

set background=dark
colorscheme PaperColor


# Install Vim-Plug plugin 

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Add the following section in ~/.vimrc file

" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')




call plug#end()

" }}}

