# Partial bashrc config file to handle creating the prompt based off of 
# justjanne/powerline-go. It will be linked by prompt-link if in use

# setup some helper variables to make options a bit more modular
GO_PROMPT_CMD_PATH="$GOBIN/powerline-go"
# PROMPT_PATH="$BASH_CONFIGS_ROOT/prompts/powerline-go"
# PROMPT_OPTS_PATH=$BASH_CONFIGS_ROOT/prompts/go-prompt-options.sh
# TODO figure out how to get all options to work, they don't now
PROMPT_OPTS_PATH=""

# get prompt options from go-prompt-options, if doesn't exist ignore
if [ -e $PROMPT_OPTS_PATH ]; then
    PROMPT_OPTIONS="$($PROMPT_OPTS_PATH)"
else PROMPT_OPTIONS=""; fi
PROMPT_STRING="$GO_PROMPT_CMD_PATH $PROMPT_OPTIONS"
# echo "Prompt command string:\n$PROMPT_STRING"

function _update_ps1() {
    PS1="$($PROMPT_STRING)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
