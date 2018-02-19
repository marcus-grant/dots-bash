# 
# myBash .bash_profile
# 
# written by Marcus Grant (2016) of thepatternbuffer.io
#

# get the bash dotfiles directory path so other configs can use it
# source profile loads environment stuff including id'ing host-specic stuff
export BASH_CONFIGS_ROOT=$(dirname "$(readlink ~/.bash_profile)")
source $BASH_CONFIGS_ROOT/bash_exports.sh

# ------------------- Always end file with below --------------------------
# Then Finally (always last) source the bashrc
# for now we will have the profile match the rc, later I will add things like system info messages so you see them on login
if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi
#EOF

export PATH="$HOME/.cargo/bin:$PATH"
