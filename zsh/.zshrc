# Lines configured by zsh-newuser-install
HISTFILE=$HOME/.histfile
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

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' history-incremental-search-backward

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Load local config
if [ -s "$HOME/.zshrc_local" ]; then
    source "$HOME/.zshrc_local"
fi

# Start or connect to a ssh-agent
source "$HOME/.ssh/get_agent.sh"

# Dotfiles update nofication
pushd > /dev/null
if [ -d "$HOME/dotfiles" ]; then
    cd "$HOME/dotfiles"
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git remote update > /dev/null 2>&1
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse @{u})
        BASE=$(git merge-base @ @{u})

        if [ $LOCAL = $REMOTE ]; then
            #echo "Up-to-date"
        elif [ $LOCAL = $BASE ]; then
            echo " #### Dotfiles are out of date! Run update-dotfiles! #### "
        fi
        #elif [ $REMOTE = $BASE ]; then
        #    echo "Need to push"
        #else
        #    echo "Diverged"
        #fi
    fi
fi
popd > /dev/null

function update-dotfiles() {
    pushd > /dev/null
    cd "$HOME/dotfiles"
    if git pull; then
        make install
        popd > /dev/null
        echo "Updates applied, restart terminals or run \"source $HOME/.zshrc\""
    fi
}

function update-remote-dotfiles() {
    for remote in klotet janner livebet; do
        if [ "$remote" = "$HOST" ]; then
            continue
        fi
        echo "Updating host $remote"
        ssh "$remote" "source .zshrc && update-dotfiles"
    done
}

# RAINBOW COLORS
RAINBOWPROMPT="$(print -P "%n")"
RAINBOWMIN=22
RAINBOWMAX=$((231 - RAINBOWMIN))
RAINBOWCOLOR=0
HOSTNAMESTRING="$(print -P "%m")"
HOSTNAMECOLOR="$((0x$(echo $HOSTNAMESTRING | md5sum | cut -c1-8) % RAINBOWMAX))"
RAINBOWHOSTNAME="%{%{[38;5;${HOSTNAMECOLOR}m%}%}$HOSTNAMESTRING"
STATICPROMPT="%{$fg_no_bold[yellow]%}%d%{$reset_color%}"$'\n'"[%{$fg_bold[magenta]%}%y%{$reset_color%}]%(!.#.$) "

PROMPT="%{$fg_no_bold[cyan]%}%n%{$reset_color%}@%{$fg_bold[blue]%}%m $STATICPROMPT" 
RPROMPT="%T [%(0?.%{$fg_no_bold[red]%}%?.%{%{[48;5;88m%}%}%?)%{%k%}%{$reset_color%}]"

function precmd() {
    local branch=""
    if git rev-parse --git-dir > /dev/null 2>&1; then
        branch=" [%{$fg_bold[cyan]%}$(git rev-parse --abbrev-ref HEAD)%{$reset_color%}]"
    fi
    STATICPROMPT="%{$fg_no_bold[yellow]%}%d%{$reset_color%}$branch"$'\n'"[%{$fg_bold[magenta]%}%y%{$reset_color%}]%(!.#.$) "
    local rainbow=""
    for i in {000..${#RAINBOWPROMPT}}; do
        rainbow="$rainbow%{%{[38;5;$(((i+RAINBOWCOLOR)%RAINBOWMAX + RAINBOWMIN))m%}%}${RAINBOWPROMPT:$i:1}"
    done
    ((RAINBOWCOLOR++))
    if [ "$RAINBOWCOLOR" -gt "$RAINBOWMAX" ]; then
        RAINBOWCOLOR=0
    fi
    PROMPT="$rainbow%{$reset_color%}@$RAINBOWHOSTNAME $STATICPROMPT"
}
# END RAINBOW COLORS
