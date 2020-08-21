.PHONY: install
install: cygwin git ssh vim zsh tmux nvim commands

.PHONY: cygwin
cygwin:
	stow cygwin

.PHONY: git
git:
	stow git

.PHONY: ssh
ssh:
	mkdir -p ../.ssh
	stow ssh
	chmod 600 ssh/.ssh/config

.PHONY: vim
vim:
	stow vim

.PHONY: zsh
zsh:
	mkdir -p ../.zsh/autocomp
	stow zsh

.PHONY: tmux
tmux:
	stow tmux

.PHONY: nvim
nvim: ../.nvim/dein/repos/github.com/Shougo/dein.vim
	mkdir -p ../.config/nvim
	stow nvim

../.nvim/dein/repos/github.com/Shougo/dein.vim:
	mkdir -p ../.nvim/dein/repos/github.com/Shougo
	git clone https://github.com/Shougo/dein.vim ../.nvim/dein/repos/github.com/Shougo/dein.vim

commands: $(addprefix /usr/local/bin/, $(patsubst commands/%,%,$(wildcard commands/*)))

/usr/local/bin/%: commands/%
	sudo chown root:root $^
	sudo chmod 755 $^
	sudo ln -s $(abspath $^) /usr/local/bin
