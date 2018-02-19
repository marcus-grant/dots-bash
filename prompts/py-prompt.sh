
#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  _update_ps
#   DESCRIPTION:  updates PS1 prompt using powerline-shell.py
#    PARAMETERS:  no params, but uses /bashrc/path/powerline-shell.py
#       RETURNS:  
#-------------------------------------------------------------------------------
function _update_ps1 ()
{
    PS1="$($BASH_CONFIGS_ROOT/prompts/powerline-shell.py $? 2> /dev/null)" 
}	# ----------  end of function _update_ps1  ----------

if [ "$TERM" != "linux" ]; then
        PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
