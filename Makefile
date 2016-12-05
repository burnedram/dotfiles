.PHONY: install cygwin git ssh vim zsh hooks tmux

install: cygwin git ssh vim zsh hooks tmux nvim

cygwin:
	stow cygwin

git:
	stow git

ssh:
	stow ssh

vim:
	stow vim

zsh:
	stow zsh

tmux:
	stow tmux

.PHONY: nvim
nvim: ~/.nvim/dein/repos/github.com/Shougo/dein.vim
	stow nvim

~/.nvim/dein/repos/github.com/Shougo/dein.vim:
	mkdir -p ~/.nvim/dein/repos/github.com/Shougo
	git clone https://github.com/Shougo/dein.vim ~/.nvim/dein/repos/github.com/Shougo/dein.vim
