# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt nomatch
unsetopt appendhistory autocd beep extendedglob notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/Rafael/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Begin user settings
autoload -U colors
colors

# RAINBOW COLORS
RAINBOWPROMPT="$(print -P "%n@%m")"
RAINBOWMIN=16
RAINBOWMAX=$((231 - RAINBOWMIN))
RAINBOWCOLOR=10
STATICPROMPT="%{$fg_no_bold[yellow]%}%d"$'\n'"[%{$fg_bold[magenta]%}%y%{$reset_color%}]%(!.#.$) "

PROMPT="%{$fg_no_bold[cyan]%}%n%{$reset_color%}@%{$fg_bold[blue]%}%m $STATICPROMPT" 
RPROMPT="%T [%(0?.%{$fg_no_bold[red]%}%?.%{%K{red}%}%?)%{%k%}%{$reset_color%}]"

function precmd() {
    local rainbow=""
    for i in {000..${#RAINBOWPROMPT}}; do
        rainbow="$rainbow%{%{[38;5;$(((i+RAINBOWCOLOR)%RAINBOWMAX + RAINBOWMIN))m%}%}${RAINBOWPROMPT:$i:1}"
    done
    ((RAINBOWCOLOR++))
    if [ "$RAINBOWCOLOR" -gt "$RAINBOWMAX" ]; then
        RAINBOWCOLOR=0
    fi
    PROMPT="$rainbow $STATICPROMPT"
}
# END RAINBOW COLORS

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' history-incremental-search-backward

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Start or connect to a ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    AGENTPID=$(ps -A | grep -m 1 ssh-agent | awk '{print $1}')
    if [ -z "$AGENTPID" ]; then
        ssh-agent | sed 's/^echo/#echo/' > "$HOME/.ssh/agent"
        source "$HOME/.ssh/agent" 
        ssh-add
    else
        source "$HOME/.ssh/agent" 
    fi
fi
