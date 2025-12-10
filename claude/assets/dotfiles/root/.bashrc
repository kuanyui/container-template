# This is the ~/.bashrc inside the container

PS1='\[\e[1;32m\]\u@\h\[\e[m\]:\[\e[1;34m\]\W\[\e[1;33m\]\$\[\e[m\] '

# Prevent Emacs TRAMP from failed to match the shell prompt.
if [ "$TERM" = "dumb" ]; then
    PS1='$ '
    unset PROMPT_COMMAND
    [ -n "$ZSH_VERSION" ] && unsetopt zle 2>/dev/null
fi

alias sz="source ~/.bashrc"
alias ll='ls -al --color=auto '
alias ls='ls --color=auto '

alias sc="sudo systemctl"
alias jc="sudo journalctl"
alias jc-clear="sudo journalctl --vacuum-time=5d"   #  Delete journal logs which are older than 5 days

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

export HISTCONTROL=ignorespace
