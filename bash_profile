# 
# myBash .bash_profile
# 
# written by Marcus Grant (2016) of thepatternbuffer.io
#

# Bash profile which should be loading profile then bashrc
# This should be for stuff that gets done once per login
# First get BASH_CONFIGS_ROOT
source ~/.profile

# Handle ssh-keys here using bash_ssh.sh config script
source $BASH_CONFIGS_ROOT/bash_ssh.sh


# TODO remove this if everything works, bash_exports gets sourced in ~/.profile
# get the bash dotfiles directory path so other configs can use it
# source profile loads environment stuff including id'ing host-specic stuff
# source $BASH_CONFIGS_ROOT/bash_exports.sh

# ------------------- Always end file with below --------------------------
# Then Finally (always last) source the bashrc
# for now we will have the profile match the rc, later I will add things like system info messages so you see them on login
if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi
