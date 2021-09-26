# Settings for this configuration
export BASH_PROMPT_NAME='minimal'

# Get dotfile directory as DOTS_DIR & bash dotfiles subdir as DOTS_DIR_BASH
_DOTSDIRSRC="${BASH_SOURCE[0]}"
while [ -h "$_DOTSDIRSRC" ]; do # resolve $_DOTSDIRSRC until the file is no longer a symlink
  DOTS_DIR_BASH="$( cd -P "$( dirname "$_DOTSDIRSRC" )" >/dev/null 2>&1 && pwd )"
  _DOTSDIRSRC="$(readlink "$_DOTSDIRSRC")"
  [[ $_DOTSDIRSRC != /* ]] && _DOTSDIRSRC="$DOTS_DIR_BASH/$_DOTSDIRSRC" # if $_DOTSDIRSRC was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DOTS_DIR_BASH="$( cd -P "$( dirname "$_DOTSDIRSRC" )" >/dev/null 2>&1 && pwd )"
DOTS_DIR="$(dirname "$DOTS_DIR_BASH")"

# Load custom local-only overrides early in case there's stuff here to override
if [ -f $DOTS_DIR_BASH/bashlocal.bash ]; then source $DOTS_DIR_BASH/bashlocal.bash; fi

# DELETEME: After change over away from Bash-It is complete
# Set BASH_IT directory and clone it if it doesn't exist already
# if [ -z $BASH_IT ]; then export BASH_IT="$DOTS_DIR_BASH/bash-it"; fi
# if [ ! -d $BASH_IT ]; then
#     echo
#     echo "Bash-It not installed, installing now..."
#     echo
#     git clone --depth=1 https://github.com/Bash-it/bash-it.git $BASH_IT
# fi

# DELETEME: After v3 works
# Setup Basher if it doesn't already exist
# BASHER_ROOT is where basher will look for all its lookups
# BASHER_PREFIX is where it will install all packages
# if [ -z $BASHER_ROOT ]; then export BASHER_ROOT="$DOTS_DIR_BASH/basher"; fi
# if [ -z $BASHER_PREFIX ]; then export BASHER_PREFIX="$BASHER_ROOT/cellar"; fi
# if [ ! -d $BASHER_ROOT ]; then
#     echo
#     echo "Basher not installed, installing now..."
#     echo
#     git clone --depth=1 https://github.com/basherpm/basher.git $BASHER_ROOT
# fi

# DELETEME: Part of basher
# Should this be in profile? https://unix.stackexchange.com/a/26059
# export PATH="$PATH:$BASHER_ROOT/bin"
# eval "$(basher init - bash)" # replace `bash` with `zsh` if you use zsh

# Some defaults
export EDITOR="vim"
source $DOTS_DIR_BASH/rc.bash
