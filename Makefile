.PHONY: install cygwin git ssh vim zsh hooks

install: cygwin git ssh vim zsh hooks

cygwin:
	stow cygwin

git:
	stow git

ssh:
	chmod 0600 ssh/.ssh/*_rsa
	stow ssh

vim:
	stow vim

zsh:
	stow zsh

hooks:
	stow -t .git/hooks hooks
