# ┌─-[e696b6ce80db]─[~]
# └──❯

# TODO:
# - username@hostname
#   - purple for both if not root
#   - red for both if root
# - pwd in green after
# - final arrow should be a green arrow if $? == 0, red arrow if $?==0 && root, red X if $?!=0 


# Colors
export _FG_BLK='\[\e[0;30m\]'
export _FG_RED='\[\e[0;31m\]'
export _FG_GRN='\[\e[0;32m\]'
export _FG_YEL='\[\e[0;33m\]'
export _FG_BLU='\[\e[0;34m\]'
export _FG_PUR='\[\e[0;35m\]'
export _FG_CYN='\[\e[0;36m\]'
export _FG_GRY='\[\e[0;37m\]'
export _FG_CLR='\[\e[0m\]'

_PROMPT_STAT_SYMBOL_SUCCESS='❯'
_PROMPT_STAT_COLOR_SUCCESS=$_FG_GRN
_PROMPT_STAT_SYMBOL_FAIL='X'
_PROMPT_STAT_COLOR_FAIL=$_FG_RED

_PROMPT_USER_ROOT_COLOR=$_FG_RED
_PROMPT_USER_NONROOT_COLOR=$_FG_PUR

_PROMPT_HOSTNAME_LOCAL_COLOR=$_FG_CYN
_PROMPT_HOSTNAME_REMOTE_COLOR=$_FG_PUR

_PROMPT_PWD_MAX_COLS=50
_PROMPT_PWD_COLOR=$_FG_GRN
_PROMPT_PWD_USE_GIT=0 # 0 for true
_PROMPT_PWD_DIRTRIM=3 # # of subdirectory levels before trimming
# https://stackoverflow.com/a/26555347
_PROMPT_PWD_SED_REGEX='s|^([^/]*/[^/]*/).*(/[^/]*)|\1..\2|'

# 0 true, any other number false
_PROMPT_GIT_ENABLED=0
_PROMPT_GIT_BRANCH_ENABLED=0
_PROMPT_GIT_UNTRACKED_ENABLED=0 
_PROMPT_GIT_UNTRACKED_SYMBOL='!?'
_PROMPT_GIT_UNTRACKED_COLOR=$_FG_RED
_PROMPT_GIT_BRANCH_COLOR=$_FG_YEL


function prompt_root_user {
    local _USER=''
    if [[ $EUID -eq 0 ]]; then
        _USER+=$_PROMPT_USER_ROOT_COLOR
    else
        _USER+=$_PROMPT_USER_NONROOT_COLOR
    fi
    echo "$_USER\u$_FG_CLR"
}

function prompt_hostname_remote {
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        echo "$_PROMPT_HOSTNAME_REMOTE_COLOR\h$_FG_CLR"
    else
        echo "$_PROMPT_HOSTNAME_LOCAL_COLOR\h$_FG_CLR"
    fi
}

# sed command to trim pwd comes from below link:
# 
function prompt_conditional_pwd {
    local _PWD=$(dirs)
    export PROMPT_DIRTRIM=0
    if [ -d "${_PWD}/.git" ] && [ $_PROMPT_PWD_USE_GIT ]; then
        echo "$_PROMPT_PWD_COLOR$(basename $_PWD)$_FG_CLR"
        return 0
    fi
    if [ ${#_PWD} -gt $_PROMPT_PWD_MAX_COLS ]; then
        _PWD=$(echo $_PWD | sed -E -e "s|^$HOME|~|" -e $_PROMPT_PWD_SED_REGEX)
    fi
    echo "$_PROMPT_PWD_COLOR$_PWD$_FG_CLR"
}

function prompt_git_untracked {
    if  [ $_PROMPT_GIT_UNTRACKED_ENABLED -eq 0 ]; then
        if ! git diff-files --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]
        then
            echo "$_PROMPT_GIT_UNTRACKED_COLOR$_PROMPT_GIT_UNTRACKED_SYMBOL"
        else
            echo ''
        fi
    else
        echo ''
    fi
}


function prompt_git_branch {
    local _GIT_BRANCH="$(git branch --show-current)"

    if [ ! -z $_GIT_BRANCH ] && [ $_PROMPT_GIT_UNTRACKED_ENABLED -eq 0 ]; then
        echo "${_PROMPT_GIT_BRANCH_COLOR}${_GIT_BRANCH}"
    else
        echo ''
    fi
}

function prompt_git {
    echo "$(prompt_git_branch)$(prompt_git_untracked)$_FG_CLR"
}

# One arg, status/return code
function prompt_status_symbol {
    local _STAT
    if [ $1 == 0 ] ; then
        _STAT+="${_PROMPT_STAT_COLOR_SUCCESS}$_PROMPT_STAT_SYMBOL_SUCCESS$_FG_CLR"
    else
        _STAT+="${_PROMPT_STAT_COLOR_FAIL}$_PROMPT_STAT_SYMBOL_FAIL$_FG_CLR"
    fi
    echo $_STAT
}

function prompt_command {
    # Return code must be captured first or it will take the rc of last op
    local _RC="$?"


    local PROMPT='┌──'

    PROMPT+="[$(prompt_root_user)@$(prompt_hostname_remote)]"
    PROMPT+="─[$(prompt_conditional_pwd)]"

    # Only run if a .git directory present here
    if [ -d "$(pwd)/.git" ]; then
        PROMPT+="─[$(prompt_git)$_FG_CLR]"
    fi
    # PROMPT+='-[git]'

    PROMPT+="\n└──$(prompt_status_symbol $_RC) "
    # Determine color red by either root or nonzero return code
    # if [[ $? -ne 0 ]] || [[ $EUID -eq 0 ]] ; then
    export PS1="$PROMPT"
}

export PROMPT_COMMAND=prompt_command
unset _PROMPT
