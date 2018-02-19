########
#
# MyBash .bashrc file
#
# written by Marcus Grant (2016) of thepatternbuffer.com
#
########

# make sure BASH_CONFIGS_ROOT is exported
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
