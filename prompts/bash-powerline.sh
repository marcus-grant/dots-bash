#!/usr/bin/env bash

## Uncomment to disable git info
#POWERLINE_GIT=0

__powerline() {
    # Colorscheme
    COLOR_FG_BLACK='\[\033[0;30m\]' # black
    COLOR_FG_RED='\[\033[0;31m\]' # red
    COLOR_FG_GREEN='\[\033[0;32m\]' # green
    COLOR_FG_YELLOW='\[\033[0;33m\]' # yellow
    COLOR_FG_BLUE='\[\033[0;34m\]' # blue
    COLOR_FG_MAGENTA='\[\033[0;35m\]' # magenta/purple
    COLOR_FG_CYAN='\[\033[0;36m\]' # cyan
    RESET='\[\033[m\]'
    # COLOR_CWD='\[\033[0;34m\]' # blue
    COLOR_CWD=$COLOR_FG_YELLOW
    # COLOR_GIT='\[\033[0;36m\]' # cyan
    COLOR_GIT=$COLOR_FG_MAGENTA
    COLOR_SUCCESS='\[\033[0;32m\]' # green
    COLOR_FAILURE='\[\033[0;31m\]' # red

    # TODO Consider more angle brackets as signals like venv
    SYMBOL_FAILURE="$COLOR_FAILURE×$RESET"
    SYMBOL_SUCCESS_USER="$COLOR_SUCCESS▶$RESET"
    SYMBOL_SUCCESS_ROOT="$COLOR_FAILURE▶$RESET"

    SYMBOL_GIT_BRANCH='⑂ '
    SYMBOL_GIT_MODIFIED='*'
    SYMBOL_GIT_PUSH='↑'
    SYMBOL_GIT_PULL='↓'

    # TODO not sure what this is for, can we DELETEME
    # if [[ -z "$PS_SYMBOL" ]]; then
    #   # If you want to use a symbol based on OS uncomment
    #   # case "$(uname)" in
    #   #     Darwin)   PS_SYMBOL='';;
    #   #     Linux)    PS_SYMBOL='$';;
    #   #     *)        PS_SYMBOL='%';;
    #   # esac
    #   PS_SYMBOL=""
    #   if [ $? -ne 0 ]; then # If last command failed
    #       PS_SYMBOL="$SYMBOL_FAILURE"
    #   else
    #       if [ $(id) -eq 0 ]; then # If root user
    #           PS_SYMBOL="$SYMBOL_SUCCESS_ROOT"
    #       else
    #           PS_SYMBOL="$SYMBOL_SUCCESS_USER"
    #       fi
    #   fi
    # fi

    __git_info() { 
        [[ $POWERLINE_GIT = 0 ]] && return # disabled
        hash git 2>/dev/null || return # git not found
        local git_eng="env LANG=C git"   # force git output in English to make our work easier

        # get current branch name
        local ref=$($git_eng symbolic-ref --short HEAD 2>/dev/null)

        if [[ -n "$ref" ]]; then
            # prepend branch symbol
            ref=$SYMBOL_GIT_BRANCH$ref
        else
            # get tag name or short unique hash
            ref=$($git_eng describe --tags --always 2>/dev/null)
        fi

        [[ -n "$ref" ]] || return  # not a git repo

        local marks

        # scan first two lines of output from `git status`
        while IFS= read -r line; do
            if [[ $line =~ ^## ]]; then # header line
                [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PUSH${BASH_REMATCH[1]}"
                [[ $line =~ behind\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PULL${BASH_REMATCH[1]}"
            else # branch is modified if output contains more lines after the header line
                marks="$SYMBOL_GIT_MODIFIED$marks"
                break
            fi
        done < <($git_eng status --porcelain --branch 2>/dev/null)  # note the space between the two <

        # print the git branch segment without a trailing newline
        printf " $ref$marks"
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly. 
        if [ $? -eq 0 ]; then
            # local symbol="$COLOR_SUCCESS $PS_SYMBOL $RESET"
            if [ $EUID -eq 0 ]; then # if success, use root or user symbol
                local symbol="$SYMBOL_SUCCESS_ROOT"
            else
                local symbol="$SYMBOL_SUCCESS_USER"
            fi
        else # if failed then use the failure symbol
            # local symbol="$COLOR_FAILURE $PS_SYMBOL $RESET"
            local symbol="$SYMBOL_FAILURE"
        fi

        local cwd="[ $COLOR_CWD\w$RESET ]"
        # Bash by default expands the content of PS1 unless promptvars is disabled.
        # We must use another layer of reference to prevent expanding any user
        # provided strings, which would cause security issues.
        # POC: https://github.com/njhartwell/pw3nage
        # Related fix in git-bash: https://github.com/git/git/blob/9d77b0405ce6b471cb5ce3a904368fc25e55643d/contrib/completion/git-prompt.sh#L324
        __powerline_git_info="$(__git_info)"
        if [ -z "$__powerline_git_info" ]; then
            local git=""
        else
            local git="─[$COLOR_GIT\${__powerline_git_info}$RESET ]"
        fi
        # TODO Deleteme? need to detect if git is present
        # if shopt -q promptvars; then
        #     __powerline_git_info="$(__git_info)"
        #     if [ -z "$__powerline_git_info" ]; then
        #         local git=""
        #     else
        #         local git="─[ $COLOR_GIT\${__powerline_git_info}$RESET ]"
        #     fi
        # else # TODO I might actually enforce extra referencing for safey DELETEME?
        #     # promptvars is disabled. Avoid creating unnecessary env var.
        #     # local git="─[ $COLOR_GIT$(__git_info)$RESET ]"
        #     __powerline_git_info="$(__git_info)"
        #     if [ -z "$__powerline_git_info" ]; then
        #         local git=""
        #     else
        #         local git="─[ $COLOR_GIT\${__powerline_git_info}$RESET ]"
        #     fi
        #
        # fi

        PS1="┌─$cwd$git\n└─$symbol "
    }

    PROMPT_COMMAND="ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

__powerline
unset __powerline
