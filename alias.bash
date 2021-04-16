# General Aliases, should be used on all systems

# Start by determining which ls color option should be used
# This is especially odd for MacOS & Windows
if ls --color -d . &> /dev/null; then
  alias ls="ls --color=auto"
elif ls -G -d . &> /dev/null; then
  alias ls='ls -G' # Compact view & mac compatibility view w/ color
fi

# List Directory Contents
alias sl=ls # Common misspelling
alias l='ls -a'
alias la='ls -AF' # Compact list view with hidden
alias l1='ls -1'
alias ll='ls -ahl' # List view, all, in human-readable
alias lt='ll -t' # ll but sorted by time, newest first
alias ltr='lt -r' # lt but reverse order, oldest first
alias lz='ll -S' # ll but sorted by size, largest first
alias lzr='lz -r' # lz but reverse order, smallest first

# Short sudo
alias _='sudo'

# Edit bash files with shortcut and quickly reload them
alias edit="$EDITOR"
alias ebrc="edit ~/.bashrc"
alias ebpf="edit ~/.bash_profile"
alias rbrc="source ~/.bash_profile; source ~/.bashrc"

# Colored grep
# Needs to check on a known existing file for a pattern that
# is known to ensure OS supports the color option
export _GREP_HAS_COLOR=false
if grep --color=auto "a" "${DOTS_DIR_BASH}/"*.md &> /dev/null; then
  alias grep='grep --color=auto'
  alias grepc='grep --color=always'
  export _GREP_HAS_COLOR=true
fi
grepl() {
  if [ $_GREP_HAS_COLOR = true ]; then
    grepc $@ | less -R;
  else
    grep $@ | less;
  fi
}
