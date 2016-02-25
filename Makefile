.PHONY: install cygwin git ssh vim zsh hooks

install: cygwin git ssh vim zsh hooks

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

hooks:
	stow -t .git/hooks hooks
