########
#
# All Bash Aliases Are defined here
#
########

# Navigation (cd) {{{
#CD - All cd aliases for quickly changing directories
#  alias ios='cd $HOME/Dropbox/Dev/iOS'
alias dev='cd $MY_CODE_DIR'
alias pydev='cd $HOME/code/python'
alias webdev='cd $HOME/code/web'
alias aidev='cd $HOME/code/ai'
alias godev='cd $HOME/code/go'
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
# These things differ between Linux & Mac, so it's important to set aliases based on whether $MACHINE is "linux" or "mac"
if [ "$MACHINE" == "mac" ]; then
    alias lsnc='ls'
    alias lnc="ls -lh"
    alias lc='ls -G'
    alias lanc='lc -lah'
    alias l='lc -lh' # exclude hidden, longform, human-readable filesize, excl. grp
    alias la='lc -lah' # same as above, but incl. grps & hiddens
    alias lt='lc -lahtr' # sort by time same as la but without groups, rev order
    alias lS='lc -lahSr' # same as ^ but with filesize & reversed for ez view
else
    alias lsnc='ls --color=never'
    alias lnc='ls -lhG'
    alias lanc='lc -lah'
    alias lc='ls --color=always'
    alias l='lc -lhG' # exclude hidden, longform, human-readable filesize, excl. grp
    alias la='lc -lah' # same as above, but incl. grps & hiddens
    alias lt='lc -lahGtr' # sort by time same as la but without groups, rev order
    alias lS='lc -lahGSr' # same as ^ but with filesize & reversed for ez view
fi

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
alias reflector-default='sudo reflector --verbose --latest 32 --sort score --save /etc/pacman.d/mirrorlist'
#}}}

# Misc. {{{
# Python, Anaconda & Jupyter
alias jnb="jupyter-notebook"

# Vim aliasses
alias viml='vim "+set background=light"' #runs vim in a light colorscheme

# QEMU-KVM virtual machine launch aliases
alias loki="sudo $HOME/VMs/Loki/loki-start"
alias loki-headless="sudo $HOME/VMs/Loki/loki-start-headless"

# Locking/Suspend/Hibernate/Reboot to Bootloader
alias lock-lightdm="dm-tool lock"

# Git
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
alias glog="git log --format='%Cgreen%h%Creset %C(cyan)%an%Creset - %s' --graph"

# Ansible & Molecule
alias molcr="molecule create"
alias molpr="molecule prepare"
alias mols="molecule list"
alias molco="molecule converge"
alias molve="molecule verify"
alias moli="molecule lint"
alias molt="molecule test"




# MacOS
# different aliases based on if it's a mac
# TODO: Verify that this works after splitting aliases into own file and passing args
if [[ "$MACHINE" == 'mac' ]]; then
  alias dev-notes='cd $HOME/Documents/dev-notes'
elif [[ "$MACHINE" == 'linux' ]]; then
  alias dev-notes='cd $HOME/documents/dev-notes'
fi

# Fix permission errors on brew's local env permissions in brew operations
alias brew='sudo chown -R $(whoami):admin /usr/local/{lib,sbin,share} && brew'


# MAC open xcode
if [[ "$MACHINE" == "mac" ]]; then
  alias oxw='open *.xcw*'
  alias oxp='open *.xcod*'
fi

# WSL
if [[ "$MACHINE" == "wsl" ]]; then
    alias npm='/usr/bin/npm'
fi

