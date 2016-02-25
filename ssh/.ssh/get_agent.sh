#!/bin/bash

SSH_AGENT_PID=$(ps -efu $(whoami) | grep -m 1 ssh-agent | awk '{print $2}')
if [ -z "$SSH_AGENT_PID" ] || [ ! -s "$HOME/.ssh/agent" ]; then
    echo "Creating new ssh-agent"
    if [ -n "$SSH_AGENT_PID" ]; then
        kill $SSH_AGENT_PID
    fi
    ssh-agent | sed 's/^echo/#echo/' > "$HOME/.ssh/agent"
    source "$HOME/.ssh/agent"
    ssh-add
else
    source "$HOME/.ssh/agent" 
fi
