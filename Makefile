.PHONY: install
install: cygwin git ssh vim zsh tmux nvim wsl

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

.PHONY: wsl
wsl:
	@if grep Microsoft /proc/sys/kernel/osrelease 1>/dev/null 2>&1 && \
			[ -e "/mnt/c/Program Files/wsl-terminal/etc/minttyrc" ]; then \
		echo Checking wsl-terminal config...; \
		if ! diff wsl/minttyrc "/mnt/c/Program Files/wsl-terminal/etc/minttyrc" 1>/dev/null 2>&1; then \
			echo "Replacing wsl-terminal's minttyrc..."; \
			cp wsl/minttyrc "/mnt/c/Program Files/wsl-terminal/etc/minttyrc"; \
		fi \
	else \
		echo Not running BashOnWindows; \
	fi
