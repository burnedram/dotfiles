.PHONY: install cygwin git ssh vim zsh hooks tmux

install: cygwin git ssh vim zsh hooks tmux

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
