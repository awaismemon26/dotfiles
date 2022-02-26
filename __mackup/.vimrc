" Test - Set compatibility to Vim only instead of vi
set nocompatible

" Automatically wrap text that extents beyond the screen length
set wrap
set linebreak

" Always show the statusline
set laststatus=2 

" Syntax Highlighting on
syntax on

" Set default encoding to UTF8
set encoding=utf8
set fileencoding=utf8

" enable visible whitespace
set listchars=tab:»·,trail:·,precedes:<,extends:>
set list

" Set line number
set number

" Status bar
set laststatus=2

" Enable type file detection Vim will be able to try to detect the type of file in use
filetype on

" Enable plugins and load plugin for the detected file type
filetype plugin on

" Load an indent file for the detected file type
filetype indent on

" While searching though a file incrementally highlight matching characters as you type
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters
" This will allow you to search specifically for capital letters
set smartcase

" Show matching words during a search
set showmatch

" Use highlighting when doing a search
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" kubeconfig
augroup twig_ft
  au!
  autocmd BufNewFile,BufRead ~/.kube/config set syntax=yaml
augroup END

" Vim colors theme
set background=dark
colorscheme PaperColor

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')

" Automatically clear search highlights after you move your cursor 
  Plug 'haya14busa/is.vim'


call plug#end()

" }}}
