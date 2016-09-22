#!/bin/bash

new_agent() {
    echo "Creating new ssh-agent"
    ssh-agent | sed 's/^echo/#echo/' > "$HOME/.ssh/agent"
    source "$HOME/.ssh/agent"
    ssh-add
}

if [ -s "$HOME/.ssh/agent" ]; then
    SSH_AGENT_PID=$(grep "^SSH_AGENT_PID=" "$HOME/.ssh/agent" | cut -d= -f2 | cut -d\; -f1)
    if kill -0 $SSH_AGENT_PID 1>/dev/null 2>&1; then
        echo "Reusing ssh-agent"
        source "$HOME/.ssh/agent"
    else
        echo "Dead ssh-agent"
        rm "$HOME/.ssh/agent"
        new_agent
    fi
else
    new_agent
fi
