if &compatible
  set nocompatible
endif
set runtimepath+=~/.nvim/dein/repos/github.com/Shougo/dein.vim

" Find the latest libclang.so and clang headers
let g:libclang_path = system("find /usr/lib -maxdepth 1 -type d -name \"llvm-?.?\" | sort -r | head -n 1 | tr -d '\\n'").'/lib/libclang.so'
let g:clang_path = system("find /usr/lib/clang -maxdepth 1 -type d | sort -r | head -n 1 | tr -d '\\n'")


call dein#begin(expand('~/.nvim/dein')) " root path for plugins
"Dein quickstart:
"  git clone https://github.com/Shougo/dein.vim ~/.nvim/dein/repos/github.com/Shougo/dein.vim
"  nvim
"  :call dein#install()
"  :UpdateRemotePlugins

call dein#add('Shougo/dein.vim')

"Used by e.g. unite
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

"File explorer
call dein#add('Shougo/denite.nvim')

"Deoplete quickstart:
"  pip3 install neovim
call dein#add('Shougo/deoplete.nvim')
let g:deoplete#enable_at_startup = 1

"Deoplete-clang quickstart:
"  pip2 install neovim
"  pip3 install neovim
"  apt-get install clang
call dein#add('zchee/deoplete-clang')
let g:deoplete#sources#clang#libclang_path = g:libclang_path
let g:deoplete#sources#clang#clang_header = g:clang_path
let g:deoplete#sources#clang#clang_complete_database = expand("./compile_command.json")

"C-family syntax highlighter
"  pip2 install neovim
"Good readme is good. You need a relative new version of libclang.
"At least 3.8 works.
"Also, bear is useful.
call dein#add('bbchung/Clamp')
let g:clamp_libclang_path = g:libclang_path
"let g:clamp_highlight_mode = 1 " disable if using other autocompletion

"TODO fix neomake for c++. Use :Neomake! for now.
call dein#add('neomake/neomake')
"autocmd! BufWritePost * Neomake
"autocmd Filetype cpp setlocal makeprg=make
"let g:neomake_cpp_make_maker = {
"    \ 'exe': 'make',
"    \ 'args': ['%', 'CXXFLAGS="-fsyntax-only"'],
"    \ 'append_file': 0,
"    \ 'errorformat': '%f:%l:%c: %m',
"    \ }
"let g:neomake_verbose = 3
"let g:neomake_logfile = expand('~/neomake_logfile')

"Comment stuff out
call dein#add('tomtom/tcomment_vim')

call dein#end()

syntax on
set shiftwidth=4
set tabstop=4
set expandtab
set smartindent
set number
