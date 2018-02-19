#!/bin/bash - 
#===============================================================================
#
#          FILE: clone-powerline-shell.sh
# 
#         USAGE: ./clone-powerline-shell.sh 
# 
#   DESCRIPTION: Simply clones latest version of github.com/banga/powerline-shell
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Marcus Grant (), marcus.grant@patternbuffer.io
#  ORGANIZATION: 
#       CREATED: 07/04/2017 21:34
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

echo
if [ -d ./powerline-shell ]; then
    echo "Previous version of powerline shell exists!"
    echo "Removing old version"
    rm -rf powerline-shell
    echo
fi


echo "Cloning powerline shell repo into current folder"
echo


git clone https://github.com/banga/powerline-shell

echo
echo "Finished cloning repo!"
echo

exit 0
