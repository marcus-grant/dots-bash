########
#
# MyBash .bashrc file
#
# written by Marcus Grant (2016) of thepatternbuffer.com
#
########

# make sure BASH_CONFIGS_ROOT is exported
if [ ! "$BASH_CONFIGS_ROOT" ]; then
    export BASH_CONFIGS_ROOT=$(dirname "$(readlink ~/.bash_profile)")
fi

# TODO consider moving this to profile
# BASH Custom Config Variables
export bashUseCDNVM=1 # remember false is anything but 0

# TODO add local file inside gitignore to override these
# source bash_local_vars.sh

# need to get all other exports first
# TODO remove this if the movement of exports to profile works
# source $BASH_CONFIGS_ROOT/bash_exports.sh

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


# TODO: These should be moved into exports, and for fzf perhaps somewhere else
# source fzf - generated from fzf install script
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

# TODO Should these be moved to exports?
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/marcus/.local/share/google-cloud-sdk/path.bash.inc' ]; then source '/home/marcus/.local/share/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/marcus/.local/share/google-cloud-sdk/completion.bash.inc' ]; then source '/home/marcus/.local/share/google-cloud-sdk/completion.bash.inc'; fi

# TODO: Improve nvm system, this was added automatically
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
