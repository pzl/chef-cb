set nu
set nocompatible
filetype plugin indent on
syntax on
set mouse=a
set backspace=indent,eol,start
set showmatch
set incsearch
set hlsearch
set linespace=0
set ignorecase
set smartcase
set wrap
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set showcmd
set smarttab
set nohidden
"set spell

set t_Co=256
"set t_AB=^[[48;5;%dm
"set t_AF=^[[38;5;%dm

execute pathogen#infect()
set laststatus=2
set ttimeoutlen=50
let g:airline_powerline_fonts=1