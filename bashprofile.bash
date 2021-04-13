# Get dotfile directory as DOTS_DIR & bash dotfiles subdir as DOTS_DIR_BASH
_DOTSDIRSRC="${BASH_SOURCE[0]}"
while [ -h "$_DOTSDIRSRC" ]; do # resolve $_DOTSDIRSRC until the file is no longer a symlink
  DOTS_DIR_BASH="$( cd -P "$( dirname "$_DOTSDIRSRC" )" >/dev/null 2>&1 && pwd )"
  _DOTSDIRSRC="$(readlink "$_DOTSDIRSRC")"
  [[ $_DOTSDIRSRC != /* ]] && _DOTSDIRSRC="$DOTS_DIR_BASH/$_DOTSDIRSRC" # if $_DOTSDIRSRC was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DOTS_DIR_BASH="$( cd -P "$( dirname "$_DOTSDIRSRC" )" >/dev/null 2>&1 && pwd )"
DOTS_DIR="$(dirname "$DOTS_DIR_BASH")"

# Set BASH_IT directory and clone it if it doesn't exist already
export BASH_IT="$DOTS_DIR_BASH/bash-it"
if [ ! -d $BASH_IT ]; then
    echo
    echo "Bash-It not installed, installing now..."
    echo
    git clone --depth=1 https://github.com/Bash-it/bash-it.git $BASH_IT
fi
