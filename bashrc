########
#
# MyBash .bashrc file
#
# written by Marcus Grant (2016) of thepatternbuffer.com
#
########

# make sure BASH_CONFIGS_ROOT is exported
# first determine if there's a ~/.bashrc link, if not, use ~/.bash_profile
#if [[ $HOME/.bashrc -L ]]; then
#    export BASH_CONFIGS_ROOT=$(dirname "$(readlink ~/.bashrc)")
#fi
export BASH_CONFIGS_ROOT=$(dirname "$(readlink ~/.bash_profile)")

# need to get all other exports first
source $BASH_CONFIGS_ROOT/bash_exports.sh

# get absolute path to prompt link & use prompt link to get prompt
source "$BASH_CONFIGS_ROOT/prompts/prompt-link"

# source helper functions
source "$BASH_CONFIGS_ROOT/bash_functions.sh"

# source custom bash aliases
source "$BASH_CONFIGS_ROOT/bash_aliases.sh"

# source general bash configs
source "$BASH_CONFIGS_ROOT/bash_general.sh"

# source bash internal options
# TODO: create it


# source fzf - generated from fzf install script
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/marcus/.local/share/google-cloud-sdk/path.bash.inc' ]; then source '/home/marcus/.local/share/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/marcus/.local/share/google-cloud-sdk/completion.bash.inc' ]; then source '/home/marcus/.local/share/google-cloud-sdk/completion.bash.inc'; fi
