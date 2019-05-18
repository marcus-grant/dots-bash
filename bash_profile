# 
# myBash .bash_profile
# 
# written by Marcus Grant (2016) of thepatternbuffer.io
#

# Bash profile which should be loading profile then bashrc
# This should be for stuff that gets done once per login
source ~/.profile

# First get BASH_CONFIGS_ROOT

# get the bash dotfiles directory path so other configs can use it
# source profile loads environment stuff including id'ing host-specic stuff
source $BASH_CONFIGS_ROOT/bash_exports.sh

# ------------------- Always end file with below --------------------------
# Then Finally (always last) source the bashrc
# for now we will have the profile match the rc, later I will add things like system info messages so you see them on login
if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi
#EOF

# BEGIN: Block added by chef, to set environment strings
# Please see https://fburl.com/AndroidProvisioning if you do not use bash
# or if you would rather this bit of code 'live' somewhere else
# . ~/.fbchef/environment
if [ -f ~/.fbchef/environment ]; then
    . ~/.fbchef/environment
fi
# END: Block added by chef
