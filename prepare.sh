#!/bin/bash

# 
# prepare.sh
# by Marcus Grant March 2016
# marcus.grant@patternbuffer.io
#
# Description:
# A script used along with my bash configurations 
# git repository ( https://github.com/marcus-grant/mybash ).
# It links all configurations to their rightful place in the home directory
#

# I prefer to forward declare functions whenever it's advisable,
# so here, 'main' is the main execution function, that gets called at the end
function main() {
    BASH_DOTFILES_PATH=$(get-script-dir)
    BASHRC_SRC=$BASH_DOTFILES_PATH/bashrc
    BASHRC_DST=$HOME/.bashrc
    BASH_PROFILE_SRC=$BASH_DOTFILES_PATH/bash_profile
    BASH_PROFILE_DST=$HOME/.bash_profile
    PROFILE_SRC=$BASH_DOTFILES_PATH/profile
    PROFILE_DST=$HOME/.profile
    PROMPTS_DIR_PATH=$BASH_DOTFILES_PATH/prompts
    DEFAULT_PROMPT_SRC=$PROMPTS_DIR_PATH/bash-powerline.sh
    PROMPT_LINK_DST=$PROMPTS_DIR_PATH/prompt-link

    # TODO: V
    # Style the console output better and put the removal steps in line with
    # corresponding linking steps

    # Print an intro message and warn about overwritting old configs
    console-print-intro

    handle-bashrc

    handle-bash-profile

    # TODO: investigate why having profile source bash_exports causing no boot
    # handle-profile

    set-default-prompt

    update-submodules

    source-bash-profile

    console-print-outro

    exit 0
}

# This function gets the path to the directory where this script resides,
# which happens to be the root for all the bash configs.
function get-script-dir ()
{
   	source="${BASH_SOURCE[0]}"
	while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
  		dir="$( cd -P "$( dirname "$source" )" && pwd )"
  		source="$(readlink "$source")"
  		# if $source was a relative symlink, we need to resolve it relative
 		# to the path where the symlink file was located
  		[[ $source != /* ]] && source="$dir/$source"
	done
	dir="$( cd -P "$( dirname "$source" )" && pwd )"
	echo $dir
}

# Function to print to console an intro message and to warn about overwritting
# the original bashrc and bash_profile files, and asks if they want to continue
function console-print-intro() {
    echo
    echo "Preparing local environment for BASH configuration."
    echo "!!! NOTE !!!"
    echo "This will delete current ~/.bashrc and ~/.bash_profile files."
    echo "Backup if you want to keep these files around before continuing..."
    echo "Would you like to continue? [y/N]: "
    read -s -n 1 WILL_CONTINUE
    # make sure that a valid y/n/RETURN is given as response
    while ! is-valid-y-n $WILL_CONTINUE; do
      echo
      echo "That was not a valid response."
      echo "Please specify if you'd like to continue [y/N]: "
      read -s -n 1 WILL_CONTINUE
    done
    # exit the program if a 'n', 'N', or return key was given
    if [[ "$WILL_CONTINUE" = "" ]]; then exit 1;
    elif [[ "$WILL_CONTINUE" = "n" ]]; then exit 1;
    elif [[ "$WILL_CONTINUE" = "N" ]]; then exit 1;
    fi; echo; return 0
}

# checks for valid yes/no/default response and returns by exit code
function is-valid-y-n() {
  # enter is valid
  if [[ "$1" = "" ]]; then return 0;
  elif [[ "$1" = "y" ]]; then return 0;
  elif [[ "$1" = "Y" ]]; then return 0;
  elif [[ "$1" = "n" ]]; then return 0;
  elif [[ "$1" = "N" ]]; then return 0;
  fi; return 1
}

# a function that checks if the given path exists and exits with message if not
function check-file-exists-exit() {
    if [ ! -f $1 ]; then
      echo "[ERROR]: $1 doesn't exist!"
      echo "This is a programming error, please fix it!"
      exit 1
    fi
    return 0
}

function handle-bashrc() {
    check-file-exists-exit $BASHRC_SRC
    # this removes the file silently, incase it doesn't exist
    rm $BASHRC_DST 2> /dev/null
    echo "Creating new symlink for .bashrc"
    echo "$BASHRC_DST -> $BASHRC_SRC"
    ln -s $BASHRC_SRC $BASHRC_DST
    echo "...done"
    echo
}

function handle-bash-profile() {
    check-file-exists-exit $BASH_PROFILE_SRC
    rm $BASH_PROFILE_DST 2> /dev/null
    echo "Creating new symlink for .bash_profile"
    echo "$BASH_PROFILE_DST -> $BASH_PROFILE_SRC"
    ln -s $BASH_PROFILE_SRC $BASH_PROFILE_DST
    echo "...done"
    echo
}

function handle-profile() {
    check-file-exists-exit $PROFILE_SRC
    rm $PROFILE_DST 2> /dev/null
    echo "Creating new symlink for .bash_profile"
    echo "$PROFILE_DST -> $PROFILE_SRC"
    ln -s $PROFILE_SRC $PROFILE_DST
    echo "...done"
    echo
}
function set-default-prompt(){
    check-file-exists-exit $DEFAULT_PROMPT_SRC
    echo "Linking default prompt config (bash-powerline) to prompt-link."
    if [ -e $PROMPT_LINK_DST ]; then 
      echo "Previous prompt-link exists, removing it."
      rm $PROMPT_LINK_DST
    fi
    ln -s $DEFAULT_PROMPT_SRC $PROMPT_LINK_DST
    echo "...done"
    echo
}

function update-submodules(){
    echo "Updating submodules..."
    git submodule update --init --recursive
    echo "...done"
    echo
}

function source-bash-profile(){
    echo "Sourcing ~/.bash_profile to ensure new settings are available..."
    source $HOME/.bash_profile
    echo "...done"
    echo
}

function console-print-outro(){
    echo "Dotfile preperation complete!"
    echo "Exiting."
    echo
}

# Exectution of script continues once everything in the script has been read
main
unset main
