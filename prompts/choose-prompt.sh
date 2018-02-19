#!/bin/bash

# a simple helper script to swap the link for prompt-link when changing prompt
main() {
    # need the absolute path to the prompts directory
    PROMTPS_DIR_PATH="$(get-script-dir)"
    NUM_ARGS=$#
    DESIRED_PROMPT="$(validate-args "$@")"
    PROMPT_LINK_PATH="$PROMTPS_DIR_PATH/prompt-link"
    swap-prompt-link
    echo "Exiting."
}

# foolproof way to figure out where this script is placed
get-script-dir(){
    source="${BASH_SOURCE[0]}"
    while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
      dir="$( cd -P "$( dirname "$source" )" && pwd )"
      source="$(readlink "$source")"
      # if $source was a relative symlink, we need to resolve it relative
      # to the path where the symlink file was located
      [[ $source != /* ]] && source="$dir/$source"
    done
    echo "$( cd -P "$( dirname "$source" )" && pwd )"
}

# Validate script arguments, exit with message if invalid
validate-args() {
    # first create a helpful usage example to print out
    EXAMPLE_USAGE="Example:\n./choose-prompt.sh bash-powerline.sh"
    
    # check that exactly one argument for configuration to link path is given
    local ARGS_TMP="$@"
    if (( $NUM_ARGS != 1 )); then
      echo "[ERROR]: invalid number of arguments given, please use only 1 argument for path to prompt configuration"
      echo $EXAMPLE_USAGE
      exit 1
    fi
    
    # check if given path contains the base PROMTPS_DIR_PATH inside it
    # if it does, don't use PROMTPS_DIR_PATH to format the filename path
    # if it doesn't, include it
    if [[ ! $ARGS_TMP == *"$PROMTPS_DIR_PATH"* ]]; then
      ARGS_TMP="$PROMTPS_DIR_PATH/$ARGS_TMP"
    fi


    # now, that a correct absolute path has been formated --
    # check that a valid prompt file was chosen
    if [ ! -e $ARGS_TMP ]; then
      echo "[ERROR]: The given file path doesn't exist, please chose a valid path to a prompt configuration."
      echo $EXAMPLE_USAGE
      exit 1
    fi

    # finally echo out the filepath
    echo $ARGS_TMP
}

# swap the endpoint of the prompt link to the given one
# will overwrite the old one if it exists
swap-prompt-link(){
    echo "Setting prompt script... "
    # remove the file, and send rm error to null if the file doesn't exist
    rm $PROMPT_LINK_PATH 2> /dev/null
    ln -s $DESIRED_PROMPT $PROMPT_LINK_PATH
    echo "Prompt selection and swap was succesful!"
    echo "Current prompt: $DESIRED_PROMPT"
}

# execute main which handles execution order after entire script is read
main "$@"
unset main
