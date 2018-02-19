#!/bin/bash - 
#===============================================================================
#
#          FILE: patch-fonts.sh
# 
#         USAGE: ./patch-fonts.sh 
# 
#   DESCRIPTION: Patches fonts for powerline program
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Marcus Grant (), marcus.grant@patternbuffer.io
#  ORGANIZATION: 
#       CREATED: 07/04/2017 22:06
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

#check if fonts folder exists already, then remove
if [ -d fonts ]; then
    rm -rf fonts
fi
# clone
git clone https://github.com/powerline/fonts.git
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
