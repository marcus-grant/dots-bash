
# if you install git via homebrew, or install the bash autocompletion via -
# - homebrew, you get __git_ps1 which you can use in the PS1 to display the -
# - git branch.  it's supposedly a bit faster and cleaner than manually -
# - parsing through sed. i dont' know if you care enough to change it

# This function is called in your prompt to output your active git branch.
function parse_git_branch {
git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  set-prompt
#   DESCRIPTION:  The old version using static decorations for old bash PS1
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
function set-prompt {
# Define some local colors
# local   RED="\[\033[0;31m\]" # This syntax is some weird bash color stuff
local color_nc='\e[0m' # No Color
local color_white='\e[1;37m' # Some color codes that make absolutely
local color_black='\e[0;30m' # no sense to me, they're just googled snippets
local color_blue='\e[0;34m'
local color_light_blue='\e[1;34m'
local color_green='\e[0;32m'
local color_light_green='\e[1;32m'
local color_cyan='\e[0;36m'
local color_light_cyan='\e[1;36m'
local color_red='\e[0;31m'
local color_light_red='\e[1;31m'
local color_purple='\e[0;35m'
local color_light_purple='\e[1;35m'
local color_brown='\e[0;33m'
local color_yellow='\e[0;33m'
local color_light_yellow='\e[1;33m'
local color_gray='\e[0;30m'
local color_light_gray='\e[0;37m'





# ♥ ☆ - Keeping some cool ASCII Characters for reference
local char_heart="♥"
local char_open_square_bracket="["
local char_closed_square_bracket="]"



# Here is where we actually export the PS1 Variable which stores the text for your prompt
local timestamp='$color_white#'
#Old Prompt
export PS1="$color_nc[\[\e[37;44;1m\]\t\[\e[0m\]]$COLOR_red\$(parse_git_branch) \[\e[32m\]\W\[\e[0m\]\n\[\e[0;31m\]$COLOR_blue//$COLOR_RED $char_heart \[\e[0m\]"
# OLD PROMPT [user@host:pwd](git)(venv)\n:
local TOP_POINTER_LINE=$color_white'['
local USER_PROMPT=$color_light_green"\u"$COLOR_white"@"
local HOST_PROMPT=$color_light_green"\h"$COLOR_white':'
local PWD_PROMPT=$color_light_blue"\w"$COLOR_white']'
local GIT_PROMPT=$color_red$COLOR_white
local BOTTOM_PROMPT=":"
PS1=$TOP_POINTER_LINE$USER_PROMPT$HOST_PROMPT$PWD_PROMPT$color_light_yellow$(parse_git_branch)$COLOR_white'\n'$BOTTOM_PROMPT

# New prompt to look like powerline
local 
  PS2='> '
  PS4='+ '
}

set-prompt
