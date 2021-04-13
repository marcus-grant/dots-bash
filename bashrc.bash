#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration (stock config)
# export BASH_IT="/$HOME/bash-it"
# In some cases (like with docker run) bash_profile isn't called first
# Make sure it is by checking if BASH_IT is defined, if not run bash_profile
if [ -z $BASH_IT ]; then
  source ~/.bash_profile
fi
