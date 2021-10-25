#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Enable bash completion for sudo
complete -cf sudo

# First check if the crucial vars DOTS_DIR & DOTS_DIR_BASH were loaded
# In some cases, especially testing w/ Docker .bash_profile isn't called
if [ -z $DOTS_DIR ]; then source ~/.bash_profile; fi

# Load a git-ignored bashlocal.bash config file to override key variables on local installs only
if [ -f $DOTS_DIR_BASH/bashlocal.bash ]; then source $DOTS_DIR_BASH/bashlocal.bash; fi

# General Aliases
source "$DOTS_DIR_BASH"/alias.bash

# Prompt choose one from ./prompts directory
# source "$DOTS_DIR_BASH"/prompts/starship-prompt.bash
# source "$DOTS_DIR_BASH/prompts/minimal.bash"
if [[ -z $BASH_PROMPT_NAME ]]; then
    export BASH_PROMPT_NAME='minimal'
fi
source "$DOTS_DIR_BASH/prompts/$BASH_PROMPT_NAME.bash"

# Plugins
source "$DOTS_DIR_BASH/plugins/systemd.bash"
source "$DOTS_DIR_BASH/plugins/fzf.bash"

# TODO: Move these to a templated local file
source "$DOTS_DIR_BASH/plugins/firewalld.bash"
source "$DOTS_DIR_BASH/plugins/asdf.bash"


# TODO not sure if this is the best way to handle this
# * [x] Works w/o on Pop_OS
# * [ ] Works w/o on Debian
# * [ ] Works w/o on Fedora
# * [ ] Works w/o on MacOS
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
