########
#
# All Bash Aliases Are defined here
#
########

# Navigation (cd) {{{
#CD - All cd aliases for quickly changing directories
#  alias ios='cd $HOME/Dropbox/Dev/iOS'
alias dev='cd $HOME/code'
alias pydev='cd $HOME/code/python'
alias webdev='cd $HOME/code/web'
alias aidev='cd $HOME/code/ai'
alias dotfiles='cd $HOME/dotfiles'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# These aliases allow the saving of one PresentWorkingDirectory (pwd)
# This can then be recalled to take you back to that location
alias remember-location='export tmp_location=$(pwd)'
alias recall-location='cd $tmp_location'
#}}}

# Filesystem (ls, grep, ...) {{{
# Set all common options desired on ls first by replacing the default ls command, here, I want to force color always on ls
alias ls='ls --color=always'
# alias l='ls -lahG'
alias l='ls -lhG' # exclude hidden, longform, human-readable filesize, excl. grp
alias la='ls -lah' # same as above, but incl. grps & hiddens
alias lt='ls -lahGtr' # sort by time same as la but without groups, rev order
alias lS='ls -lahGSr' # same as ^ but with filesize & reversed for ez view

# Grep
alias grep='grep --color=auto'
alias igrep='grep -i' # a grep alias for case insensitive searches
#}}}

# System (xclip, xserver, input) {{{

# system sysctl service etc.
alias scl="sudo systemctl"

# Source bashrc
alias bash-reload-rc='source $HOME/.bashrc'

# Use xclip to get & set the clipboard
alias clipin='xclip -i -selection clipboard'
alias clipout='xclip -o -selection clipboard'

# Xresources
alias xup='xrdb $HOME/.Xresources'

# Pacman
alias pacman='sudo pacman --color always'
#}}}

# Misc. {{{
# Python, Anaconda & Jupyter
alias jnb="jupyter-notebook"

# Vim aliasses
alias viml='vim "+set background=light"' #runs vim in a light colorscheme

# QEMU-KVM virtual machine launch aliases
alias loki="sudo $HOME/VMs/Loki/loki-start"
alias loki-headless="sudo $HOME/VMs/Loki/loki-start-headless"
#}}}

# Git {{{
alias gcl="git clone"
alias gst="git status"
alias gl="git pull"
alias gp="git push"
alias gd="git diff | mate"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gb="git branch"
alias gba="git branch -a"
alias gcam="git commit -am"
#}}}

# MacOS {{{
# different aliases based on if it's a mac
# TODO: Verify that this works after splitting aliases into own file and passing args
if [[ "$MACHINE" == 'mac' ]]; then
  alias dev-notes='cd $HOME/Documents/dev-notes'
elif [[ "$MACHINE" == 'linux' ]]; then
  alias dev-notes='cd $HOME/documents/dev-notes'
fi

# MAC open xcode
if [[ "$MACHINE" == "mac" ]]; then
  alias oxw='open *.xcw*'
  alias oxp='open *.xcod*'
fi
#}}}

