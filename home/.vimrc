set shell=/bin/bash
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" Powerline setup
" set guifont=Inconsolata\ for\ Powerline.otf\ 12
" set laststatus=2

Plugin 'tpope/vim-fugitive'

Plugin 'tpope/vim-surround'

Plugin 'tpope/vim-repeat'

Plugin 'tpope/vim-markdown'

Plugin 'godlygeek/tabular'

" Plugin 'klen/python-mode'

" Plugin 'kien/ctrlp.vim'
" Plugin 'davidhalter/jedi-vim'

Plugin 'tomasr/molokai'

" Plugin 'sickill/vim-monokai'

Plugin 'Lokaltog/vim-distinguished'

Plugin 'fatih/vim-go'

Plugin 'rust-lang/rust.vim'

Plugin 'dhruvasagar/vim-table-mode'

Plugin 'Valloric/YouCompleteMe'

Plugin 'vitalk/vim-simple-todo'

Plugin 'pearofducks/ansible-vim'

Plugin 'tpope/vim-speeddating'

Plugin 'vimoutliner/vimoutliner'

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" We've installed powerline using pip, so set it up here instead of with
" vundle

python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
set laststatus=2

syntax on
set number
set background=dark
set t_Co=256
colorscheme molokai

let g:pymode_lint = 1
let g:pymode_ling_checker = "pyflakes,pep8"
let g:pymode_lint_write = 1
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
" let g:pymode_syntax_indent_errors = g:pymode_syntax_all
" let g:pymode_syntax_space_errors = g:pymode_syntax_all
let g:pymode_folding = 0
