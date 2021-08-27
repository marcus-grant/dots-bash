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

# Path to the bash it configuration (stock config)
# export BASH_IT="/$HOME/bash-it"
# In some cases (like with docker run) bash_profile isn't called first
# Make sure it is by checking if BASH_IT is defined, if not run bash_profile
if [ -z $BASH_IT ]; then source ~/.bash_profile; fi
# Same for BASHER
if [ -z $BASHER_ROOT ]; then source ~/.bash_profile; fi

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
# if [ -z $BASH_IT_THEME ]; then export BASH_IT_THEME='modern'; fi

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# (Advanced): Change this to the name of the main development branch if
# you renamed it or if it was changed for some reason
# export BASH_IT_DEVELOPMENT_BRANCH='master'

# Your place for hosting Git repos. I use this for private repos.
# export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='weechat'

# Set this to false to turn off version control status checking within the prompt for all themes
if [ -z $SCM_CHECK ]; then export SCM_CHECK=false; fi
# Set to actual location of gitstatus directory if installed
# export SCM_GIT_GITSTATUS_DIR="$DOTS_DIR_BASH/gitstatus"
# Per default gitstatus uses 2 times as many threads as CPU cores, you can change this here if you must
#export GITSTATUS_NUM_THREADS=8
# Check if gitstatus is installed, clone it if not
# if [ ! -d $SCM_GIT_GITSTATUS_DIR -a "$SCM_CHECK" == "true" ]; then
#   git clone --depth=1 https://github.com/romkatv/gitstatus.git $SCM_GIT_GITSTATUS_DIR
# fi

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# If your theme use command duration, uncomment this to
# enable display of last command duration.
#export BASH_IT_COMMAND_DURATION=true
# You can choose the minimum time in seconds before
# command duration is displayed.
#export COMMAND_DURATION_MIN_SECONDS=1

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh

# MARCUS GRANT's PERSONAL v3 additions to bash dotfiles
# Should go after Bash It invocation to make sure they override them

# General Aliases
source "$DOTS_DIR_BASH"/alias.bash
# Prompt choose one from ./prompts directory
source "$DOTS_DIR_BASH"/prompts/starship-prompt.bash

# Plugins
source "$DOTS_DIR_BASH/plugins/systemd.bash"
source "$DOTS_DIR_BASH/plugins/fzf.bash"


# TODO not sure if this is the best way to handle this
# * [x] Works w/o on Pop_OS
# * [ ] Works w/o on Debian
# * [ ] Works w/o on Fedora
# * [ ] Works w/o on MacOS
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
