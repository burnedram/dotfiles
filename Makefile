.PHONY: install cygwin git ssh vim zsh

install: cygwin git ssh vim zsh

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
