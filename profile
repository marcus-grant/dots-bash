# used to properly source bash_exports on GUI logins
export BASH_CONFIGS_ROOT=$(dirname "$(readlink ~/.bash_profile)")                                                                                                                                                                                                                                                              
source $BASH_CONFIGS_ROOT/bash_exports.sh
