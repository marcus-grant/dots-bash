# 
#
# Description:
#
# # Here is where more general bashrc configurations that don't belong in any
# # other partial config file.

# TODO: Add an alternative profile for when intended to be installed on remote server, git ssh keys shouldn't be stored there, use HTTPS instead
# TODO: OR consider a better private key passwording method
# if a linux system, add all keychains in if statement below with paths
if [ $MACHINE == "linux" ] | [ $MACHINE == "wsl" ]; then
  if [ -f $HOME/.ssh/git.key ]; then
      eval $(keychain --eval --quiet $HOME/.ssh/git.key )
  else
      echo "Attempted to add git keychain, but no keyfile exists, ignoring..."
  fi
#else
  #if [ -f $HOME/.ssh/git.key ]; then
      #eval "$(ssh-agent -s)"
      #ssh-add -Kq $HOME/.ssh/git.key
      #eval $(keychain --eval --quiet $HOME/.ssh/git.key )
  #else
      #echo "Attempted to add git keychain, but no keyfile exists, ignoring..."
  #fi
fi

# WSL fix for default file mask 
# WSL for some stupid reason sets the most permissive...
# ...file/dir permissions in its umask.
# Change it to 022 to set it to the sane linux defaults of most distros
if [[ $MACHINE == "wsl" ]]; then
    umask 022
fi



# run archey3 if it exists
# TODO: Add an else for when archey isn't there, that at the very least includes uname and hostname
if hash archey3 2>/dev/null; then
    archey3
fi

# Case-Insensitive Auto Completion
# TODO this causes "no line editing enabled" error, needs fixing
#bind "set completion-ignore-case on"

# Git Bash Completion
# Will activate bash git completion if installed
# via homebrew on macOS, or whatever linux package manager you use
# NEEDS UPDATING TO WORK ON BOTH macOS & various Linux carnations
#if [ -f `brew --prefix`/etc/bash_completion ]; then
#  . `brew --prefix`/etc/bash_completion
#fi

# RVM - NEEDS AUDITING
# Mandatory loading of RVM into the shell
# This must be the last line of your bash_profile always
#[[ -s "/Users/$USER/.rvm/scripts/rvm" ]] && source "/Users/$USER/.rvm/scripts/rvm"  # This loads RVM into a shell session.

