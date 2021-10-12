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

# PATH
export PATH="$PATH:$HOME/.cargo/bin"

# Some defaults
export EDITOR="vim"
source $DOTS_DIR_BASH/rc.bash
