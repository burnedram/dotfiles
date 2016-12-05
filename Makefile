.PHONY: install
install: cygwin git ssh vim zsh tmux nvim

.PHONY: cygwin
cygwin:
	stow cygwin

.PHONY: git
git:
	stow git

.PHONY: ssh
ssh:
	stow ssh

.PHONY: vim
vim:
	stow vim

.PHONY: zsh
zsh:
	stow zsh

.PHONY: tmux
tmux:
	stow tmux

.PHONY: nvim
nvim: ~/.nvim/dein/repos/github.com/Shougo/dein.vim
	stow nvim

~/.nvim/dein/repos/github.com/Shougo/dein.vim:
	mkdir -p ~/.nvim/dein/repos/github.com/Shougo
	git clone https://github.com/Shougo/dein.vim ~/.nvim/dein/repos/github.com/Shougo/dein.vim
