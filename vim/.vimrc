set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim' "required

Plugin 'Valloric/YouCompleteMe' "autocomplete

Plugin 'octol/vim-cpp-enhanced-highlight' "cpp highlighting

Plugin 'scrooloose/syntastic.git' "syntax checking

call vundle#end()
filetype plugin indent on
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

" Put your non-Plugin stuff after this line


" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" Standard fluff
syntax on
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
