# Mock .bashrc for Topic 05 Sandbox
case $- in
    *i*) ;;
    *) return ;;
esac

export HISTCONTROL=ignoreboth
export HISTSIZE=500
export HISTFILESIZE=1000
export SANDBOX_MODE="interactive"

alias ll='ls -la'
alias envgrep='env | sort | grep'
