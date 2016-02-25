#!/bin/sh

if [ -z "$SSH_AUTH_SOCK" ]; then
    AGENTPID=$(ps -eu $(whoami) | grep -m 1 ssh-agent | awk '{print $1}')
    if [ -z "$AGENTPID" ] || [ ! -s "$HOME/.ssh/agent" ]; then
        if [ -n "$AGENTPID" ]; then
            kill $AGENTPID
        fi
        ssh-agent | sed 's/^echo/#echo/' > "$HOME/.ssh/agent"
        source "$HOME/.ssh/agent" 
        ssh-add
    else
        source "$HOME/.ssh/agent" 
    fi
fi
