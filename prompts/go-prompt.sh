# Partial bashrc config file to handle creating the prompt based off of 
# justjanne/powerline-go. It will be linked by prompt-link if in use

# setup some helper variables to make options a bit more modular
goPromptCmdPath="$GOBIN/powerline-go"
# goPromptCmdPath="powerline-go"
# PROMPT_PATH="$BASH_CONFIGS_ROOT/prompts/powerline-go"
# PROMPT_OPTS_PATH=$BASH_CONFIGS_ROOT/prompts/go-prompt-options.sh

# All prompt options as their own var
colorizeHostname="-colorize-hostname" # colorizes hostname with hash
maxDepth="-cwd-max-depth 3" # max depth of current directory path
maxDirSize="-cwd-max-dir-size 12" # max size of ea. directory name displayed
cwdMode="-cwd-mode plain" # options are fancy, plain, dironly
mode="-mode flat" # options are patched, compatible, flat
# this sets the prioritized set of segments
# lower priority ones will be ignored if space is limited
# options are:
# aws, cwd, docker, dotenv, exit, git, gitlite, hg, host, jobs, perlbrew, 
# perms, root, ssh, time, user, venv
# TODO: Figure out how to get newline to work
modules="venv,user,host,ssh,cwd,perms,git,docker,hg,jobs,exit,root"
moduleOpt="-modules $modules"
modulePriority="venv,user,host,ssh,cwd,newline,git-branch,git-status,docker,perms,hg,jobs,exit"
modulePriorityOption="-priority $modulePriority"
maxWidth="-max-width 50" # in percent, limits the prompt width
newLine="-newline" # display prompt info in its own line above command area
errorOption="-error $?" # display exit code
theme="-theme low-contrast" # options are 'low-contrast' or default
truncateSegWidth="-truncate-segment-width 16" # min width of a segment, longer will shorten (def 16)
shortenGKE="-shorten-gke-names"

##### Path Aliases
pathAliases[0]="\~/code/web/full-stack=@fullstack"
# pathAliases[1]="\~/code/ai=@ai"
# pathAliases[2]="\~/code/data-science=@data-sci"
# pathAliases[3]="\~/code/go/src/github.com=@go"
# pathAliases[4]="\~/code/go/src/github.com/marcus-grant=@go-home"
# pathAliases[5]="\~/code/go/bin=@go-bin"
# pathAliases[6]="\~/code/python=@py-dev"
# pathAliases[7]="\~/code/embedded=@embed"
# pathAliases[8]="\~/code/rust=@rust"
# pathAliases[0]="\~/dotfiles/bash=@.bash"
# pathAliases[10]="\~/dotfiles/neovim=@.neo"
# pathAliases[11]="\~/dotfiles/tmux=@.tmux"

pathTemp="-path-aliases "
for alias in "${pathAliases[@]}"
do
    pathTemp="$pathTemp$alias,"
done

# pathAliases="${pathTemp::-2}"
# echo "$pathTemp"
# cut the trailing comma out of the path alias string
pathTemp="$(echo $pathTemp | rev | cut -c 2- | rev)"
pathAliases="$pathTemp"
# echo $pathAliases

# assemble all options in one string
# promptOptions="$colorizeHostname $maxDepth $maxDirSize $cwdMode $mode "
# promptOptions="$promptOptions $moduleOption $maxWidth $promptOptions $newLine $errorOption"
# new version with two lines in prompt
promptOpts="$maxDepth $maxWidth $maxDirSize $mode $cwdMode $theme" # non-ordered options
promptOpts="$promptOptions $moduleOption $modulePriorityOption $pathAliases $errorOption"

# to get all the options, simply use $(go-prompt-opts.sh) to capture
# the echo output below
# echo "$promptOptions"

####
#### Start of command formatter
####

# get prompt options from go-prompt-options, if doesn't exist ignore
promptCmdString="$goPromptCmdPath $promptOpts"
# promptCmdString="$goPromptCmdPath"

function _update_ps1() {
    PS1="$($promptCmdString)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
