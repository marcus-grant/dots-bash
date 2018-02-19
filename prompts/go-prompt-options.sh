#!/bin/bash
# Partial file to house all the possible options for go-prompt.
# It's seperated because it is ignored by gitignore allowing for customization
# for specific hosts and users

# All prompt options as their own var
COLORIZE_HOSTNAME="-colorize-hostname" # colorizes hostname with hash
MAX_DEPTH="-cwd-max-depth 4" # max depth of current directory path
MAX_DIR_SIZE="-cwd-max-dir-size 16" # max size of ea. directory name displayed
CWD_MODE="-cwd-mode fancy" # options are fancy, plain, dironly
MODE="-mode flat" # options are patched, compatible, flat
# this sets the prioritized set of segments
# lower priority ones will be ignored if space is limited
# options are:
# aws, cwd, docker, dotenv, exit, git, gitlite, hg, host, jobs, perlbrew, 
# perms, root, ssh, time, user, venv
MODULES="venv,user,host,ssh,cwd,perms,git,hg,jobs,exit,root"
MODULE_OPT="-modules $PRT_MODULES"
MAX_WIDTH="-max-width 80" # in percent, limits the prompt width
NEWLINE="-newline" # display prompt info in its own line above command area
ERROR_OPT="-error $?" # display exit code

# assemble all options in one string
PRT_OPTS="$COLORIZE_HOSTNAME $MAX_DEPTH $MAX_DIR_SIZE $CWD_MODE $MODE "
PRT_OPTS="$MODULE_OPT $MAX_WIDTH $PRT_OPTS $NEWLINE $ERROR_OPT"

# to get all the options, simply use $(go-prompt-opts.sh) to capture
# the echo output below
echo "$PRT_STRING"
