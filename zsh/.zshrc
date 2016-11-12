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

# Add auto completion for my funcs
fpath=(~/.zsh/autocomp $fpath)
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
check_and_notify_dotfiles() {
    if [ -d "$HOME/dotfiles" ]; then
        cd "$HOME/dotfiles"
        if check_is_git; then
            git fetch -all > /dev/null 2>&1
            if [ "$(get_git_status)" = "Behind" ]; then
                echo " #### Dotfiles are out of date! Run update-dotfiles! #### "
            fi
        fi
    fi
}

function update-dotfiles() {
    pushd > /dev/null
    cd "$HOME/dotfiles"
    if git pull; then
        make install
        popd > /dev/null
        echo "Updates applied, restart terminals or run \"source ~/.zshrc\""
        echo "Dotfiles updated, restart terminal or run \"source ~/.zshrc\"" | write $(whoami)
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
RAINBOW=""
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
    local branch_no_color=""
    local branch_color=""
    local git_string=""
    if check_is_git; then
        local branch="$(git rev-parse --abbrev-ref HEAD)"
	local commit="$(git rev-parse --short HEAD)"
        branch_no_color=" [$branch@$commit]"
        branch_color=" [%{$fg_bold[cyan]%}$branch%{$reset_color%}@%{$fg_bold[yellow]%}$commit%{$reset_color%}]"

        # Up-to-date/ahead/behind/diverged
        gitstatus="$(get_git_status)"

        # Check for staged/unstaged files
        local gitstaged=""
        if check_git_staged; then
            gitstaged="%{$fg_no_bold[green]%}S%{$reset_color%}"
        fi
        local gitunstaged=""
        if check_git_unstaged; then
            gitunstaged="%{$fg_no_bold[red]%}U%{$reset_color%}"
        fi
        local gitus="$(join_by / $gitstaged $gitunstaged)"
        if [ ! -z "$gitus" ]; then
            gitus=" [$gitus]"
        fi

        if [ "$gitstatus" = "Up-to-date" ]; then
            git_string="$branch_color $gitstatus$gitus"
        else
            # Include commit difference
            local gitcommits
            case "$gitstatus" in
                Ahead)
                    gitcommits=$(get_git_commits_ahead) 
                    if [ $gitcommits -eq 1 ]; then
                        gitcommits="$gitcommits commit"
                    else
                        gitcommits="$gitcommits commits"
                    fi
                    ;;
                Behind)
                    gitcommits=$(get_git_commits_behind)
                    if [ $gitcommits -eq 1 ]; then
                        gitcommits="$gitcommits commit"
                    else
                        gitcommits="$gitcommits commits"
                    fi
                    ;;
                Diverged)
                    gitcommits="-$(get_git_commits_behind)/+$(get_git_commits_ahead) commits"
                    ;;
            esac
            git_string="$branch_color $gitstatus $gitcommits$gitus"
        fi
    fi
    STATICPROMPT="%{$fg_no_bold[yellow]%}%d%{$reset_color%}$git_string"$'\n'"[%{$fg_bold[magenta]%}%y%{$reset_color%}]%(!.#.$) "
    updaterainbow
    updateprompt
    updatetitle "[${TTY#/dev/}] $(whoami)@$(hostname) $(pwd)$branch_no_color"
}

function preexec() {
    updatetitle "$1"
}

function updaterainbow() {
    RAINBOW=""
    for i in {000..${#RAINBOWPROMPT}}; do
        RAINBOW+="%{%{[38;5;$(((i+RAINBOWCOLOR)%RAINBOWMAX + RAINBOWMIN))m%}%}${RAINBOWPROMPT:$i:1}"
    done
    ((RAINBOWCOLOR++))
    if [ "$RAINBOWCOLOR" -gt "$RAINBOWMAX" ]; then
        RAINBOWCOLOR=0
    fi
}

function updateprompt() {
    PROMPT="$RAINBOW%{$reset_color%}@$RAINBOWHOSTNAME $STATICPROMPT"
}

function updatetitle() {
    if (( $# != 0 )) && $NOTITLE; then
        print -Pn "\e]0;$1\a"
    fi
}
# END RAINBOW COLORS

# ON EDIT BUFFER CHANGES
function self-insert() {
    zle .self-insert
    updaterainbow
    updateprompt
    zle .reset-prompt
}
zle -N self-insert

# TODO on backspace/delete
# END ON EDIT BUFFER CHANGES

NOTITLE=true
function title() {
    if (( $# == 0 )); then
        echo "usage: title [--no-title|TITLE]"
    elif [ "$1" = "--no-title" ]; then
        NOTITLE=true
    else
        NOTITLE=false
        print -Pn "\e]0;$1\a"
    fi
}

# GIT CHECKS
function check_is_git() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

function get_git_status() {
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})
    BASE=$(git merge-base @ @{u})

    if [ $LOCAL = $REMOTE ]; then
        echo "Up-to-date"
    elif [ $LOCAL = $BASE ]; then
        echo "Behind"
    elif [ $REMOTE = $BASE ]; then
        echo "Ahead"
    else
        echo "Diverged"
    fi
}

function check_git_unstaged() {
    if git diff-files --quiet --ignore-submodules --; then
        return 1
    else
        return 0
    fi
}

function check_git_staged() {
    if git diff-index --cached --quiet HEAD --ignore-submodules --; then
        return 1
    else
        return 0
    fi
}

function get_git_commits_ahead() {
    git rev-list @{u}.. --count --ignore-submodules
}

function get_git_commits_behind() {
    git rev-list ..@{u} --count --ignore-submodules
}
# END GIT CHECKS

function join_by { 
    local IFS="$1"
    shift
    echo "$*"
}
# Run dotfiles checker
(check_and_notify_dotfiles &)
unset -f check_and_notify_dotfiles
