########

# some functions need to know the host OS type, and the only argument to this script
# will be stored as variable 'machine'
machine=$1

t_error="[ERROR]:"

################ FZF, RipGrep, etc. Functions{{{

# use fd to quickly search
function fdf() {
  if command -v fd >/dev/null; then
    fd . $1 -H -E *.git* | fzf
  else
    find . $1 -type f | fzf
  fi
}

# fkill - uses fzf to find & kill (select then ENTER) a process
# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
git-fetch-branches() {
  # local branches branch
  # branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  # branch=$(echo "$branches" |
  #          fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  # git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  for branch in $(git branch --all | grep '^\s*remotes' | egrep --invert-match '(:?HEAD|master)$'); do
          git branch --track "${branch##*/}" "$branch"
  done
}

git-set-key() { eval $(ssh-agent); local keyPath="$HOME/.ssh/git.key"; ssh-add "$keyPath"; }

# search-notes() {
#     if [[ $# -ne 1 ]]; then
#         echo "Argument Error! Please use exactly one argument for the search pattern"
#         exit 1
#     fi
#     rg $1 $HOME/documents/dev-notes
# }

#}}}


################ Compression & Extract functions{{{

# A function to extract correctly any archive based on extension
# I ALWAYS forget how to properly extract all the different kinds of archives
# that exist from the command line, so this is a nice helper to have.
# USE: extract imazip.zip
#      extract imatar.tar
# TODO: Add case for unrar
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.xz)   tar xJf $1      ;; 
            *.tpxz)     pixz -d $1 "${1%.*}.tar" && tar xf "${1%.*}.tar";;
            *.tar.bz2)  tar xjf $1      ;;
            # *.tar.bz2)
            #   if [ hash lbzip2 ]; then
            #     tar -I lbzip2 -xvf $1
            #   else
            #     tar xjf $1
            #   fi; ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      unrar e $1      ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *.7zip)	    7z x $1		;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# tar-progress - tars a directory with progress bars
function tar-progress() {
  echo "Creating tar archive of $1"
  # Set records to be of size 10MB, this way checkpoints occur every 10MB
  # Note that this checks a directory's apparent size in MegaBytes
  # This means that although internally MebiBytes are used,
  # The records calculation needs to reflect the apparent size instead
  local recordSize="10M"
  local recordSizeBytes=10000000

  # from StackOverflow: http://bit.ly/2EjbQhn
  # gets number of bytes of file, might need apparent size instead
  # the cut -f1 removes everything after first non-space char
  # As noted before, the size return is in MB, NOT MiB
  local dirBytes=$(du -sb $1 | cut -f1)

  # Because the number of records are truncated, inorder to avoid
  # overflow in sending states to progress-bar, add one to number of records
  local dirRecords=$((($dirBytes / $recordSizeBytes) + 1))

  # Calculate the number of records per tick
  # let recordsPerTick=${dirRecords}/${progressTicks}
  # From StackOverflow: http://bit.ly/2EhqIg8
  # sets tar's checkpoints based on resizing records to 10MiB
  local recordSize="--record-size=10M"

  # GNU tar docs: Checkpoints http://bit.ly/2EjA2Ai
  local numCheck="--checkpoint=1"

  # GNU tar docs: 3.11 Running External Commands http://bit.ly/2EhbHLm
  # use dot action to test functionality
  tar $recordSize $numCheck \
    --checkpoint-action=exec='$HOME/bin/progress-bar $TAR_CHECKPOINT '$dirRecords' tar' \
    -cf $1.tar $1
  echo
  echo "Finished!"
}

# an internal version of the above function that is used for piping instead
function _tar-progress() {
  echo "Creating tar archive of $1"
  # Set records to be of size 10MB, this way checkpoints occur every 10MB
  # Note that this checks a directory's apparent size in MegaBytes
  # This means that although internally MebiBytes are used,
  # The records calculation needs to reflect the apparent size instead
  local recordSize="10M"
  local recordSizeBytes=10000000

  # from StackOverflow: http://bit.ly/2EjbQhn
  # gets number of bytes of file, might need apparent size instead
  # the cut -f1 removes everything after first non-space char
  # As noted before, the size return is in MB, NOT MiB
  local dirBytes=$(du -sb $1 | cut -f1)

  # Because the number of records are truncated, inorder to avoid
  # overflow in sending states to progress-bar, add one to number of records
  local dirRecords=$((($dirBytes / $recordSizeBytes) + 1))

  # Calculate the number of records per tick
  # let recordsPerTick=${dirRecords}/${progressTicks}
  # From StackOverflow: http://bit.ly/2EhqIg8
  # sets tar's checkpoints based on resizing records to 10MiB
  local recordSize="--record-size=10M"

  # GNU tar docs: Checkpoints http://bit.ly/2EjA2Ai
  local numCheck="--checkpoint=1"

  # GNU tar docs: 3.11 Running External Commands http://bit.ly/2EhbHLm
  # use dot action to test functionality
  tar $recordSize $numCheck \
    --checkpoint-action=exec='$HOME/bin/progress-bar $TAR_CHECKPOINT '$dirRecords' tar' \
    -cf - $1
  echo
  echo "Finished!"
}


# compress using gzip or pigzjk 
# TODO: replace with python program that handles everything better
function compress() {
  # validate arguments
  # 1st check for number of args
  local nThreads=$(nproc)
  if (($# < 2)); then
    local msg="[ERROR]: Incorrect arguments,"
    local msg="$msg 1st argument is compression type, 2nd is file/dir path"
    echo $msg
    exit 1
  elif (($# == 3)); then
    nThreads=$3
  fi

  # check for the 2nd arg being an existing file/dir/link
  if [ ! -f $2 ]; then
    if [ ! -d $2 ]; then
      echo "[ERROR]: 2nd argument needs to be a valid file/directory/link"
      exit 1
    fi
  fi

  # format file & firname to work for both the file path case & dir case
  # if a directory, keep a reference with ending slash, and one without
  local file="$2"
  local dir="$2"
  local isDirectory=1
  if [[ -d $1 ]]; then
    isDirectory=0
    if [[ "$1" == */ ]]; then
      file="${file::-1}"
    else
      dir="$dir/"
    fi
  fi

  # Now that it is known if directory or file...
  # check which type of of compression/archival was specified,
  # then execute that type's associated commands
  local type="$1"
  if [ isDirectory ]; then
    local tarCmd="tar-progress $file"
    case $1 in
      -t)   $tarCmd ;;
      -b)   $tarCmd && lbzip2 -zv9n $nThreads $file.tar ;; 
      -g)   $tarCmd && pigz -fvp $nThreads $file.tar ;;
      -x)   $tarCmd && pixz -p $nThreads $file.tar $file.tpxz ;;
      *)    echo "'$1' isn't an existing compression option" ;;
    esac
  else
    case $1 in
      -b)   lbzip2 -zv9n $nThreads $file ;; 
      *)    echo "'$1' isn't an existing compression option" ;;
    esac
  fi
}

function compress-xz() {
  local filename="$1"
  local dirname="$1"
  if [[ -d $1 ]]; then
    if [[ "$1" == */ ]]; then
      filename="${filename::-1}"
    else
      dirname="$dirname/"
    fi
    tar --exclude=$filename.tar.xz -cvJf $filename.tar.xz $dirname
  else
    tar -cvJf $filename.tar.xz $filename
  fi
}
#}}}


################ Time functions{{{

# get timestamp in milliseconds
function millis() {
  echo $(($(date +%s%N)/1000000))
}

# A timing function that measures the milliseconds to run the command in $1
function time-cmd() {
  local _START=$(millis)
  $@
  local _STOP=$(millis)
  local _DIFFERENCE=$(($_STOP - $_START))
  echo "Command $1 Completed!"
  echo "It took $_DIFFERENCE milliseconds to complete"
}
#}}}


################ Git Functions{{{

# Because I always forget the address format for git clones using SSH -
# here is a function that takes a string USER/REPOSITORY as only argument
function gcs () {
  local GIT_ROOT="git@github.com:marcus-grant"
  local GIT_URL="$GIT_ROOT/$1.git"
  echo
  echo "Cloning from $GIT_URL ......."
  echo
  git clone $GIT_URL
  echo
  echo "Done cloning!"
}

# Easier way to clone a personal repository ussing https
# Only argument is the repository name from my personal github acct. marcus-grant
function gch () {
  local GIT_ROOT="https://github.com/marcus-grant"
  local GIT_URL="$GIT_ROOT/$1"
  echo "Cloning from $GIT_URL ......."
  git clone $GIT_URL
  echo
  echo "Done cloning!"
}

# Git Pull All - gpa - pulls all branches to local from remote
function gpa () {
  git branch -r | grep -v '\->' | while read remote;
    do git branch --track "${remote#origin/}" "$remote";
    done
  git fetch --all
  git pull --all
}
#}}}


################ Media Functions{{{

# Helper function to recursively apply the right plex permissions
function plex-permissions()
{
  echo
  echo "Recursively changing permissions of $1 to +r +x, & owned by marcus:media"
  echo
  chown -R marcus:media "$1"
  chmod -R +x "$1"
  echo
  echo "Done! Plex servers should now be able to index & gather metadata for this folder."
  echo
}
#}}}


################ HID Input Functions{{{

function caps-as-esc()
{
    xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
}

# I've been stuck with only caps lock on before due to the above function
# This is a nifty one line python command that toggles off caps lock
function CAPS-OFF()
{
  python -c 'from ctypes import *; X11 = cdll.LoadLibrary("libX11.so.6"); display = X11.XOpenDisplay(None); X11.XkbLockModifiers(display, c_uint(0x0100), c_uint(2), c_uint(0)); X11.XCloseDisplay(display)'
}


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  toggle-touchpad
#   DESCRIPTION:  From http://bit.ly/2tUl5QN & http://bit.ly/1lsLa2r
#				Toggles touchpad on & off to the system with prompts if desired
#    PARAMETERS:  -q or --quiet if no prompts are wanted, otherwise it will
#       RETURNS:  Nothin but an echo and notify-osd even by default
#-------------------------------------------------------------------------------
toggle-touchpad ()
{	
	IS_QUIET=0
	if (( $# > 0 )); then
		if [[ "$1" == "-q" ]] || [[ "$1" == "--quiet" ]]; then
			IS_QUIET=1
		else
			echo ""
			echo "[ERROR] bashrc:toggle-touchpad(): wrong argument given, only -q or --quiet or nothing permitted"
			echo "By default the toggle invokes bash echo outs and notify osd prompts"
			echo ""
		fi
	fi 
    declare -i ID
    ID=`xinput list | grep -Eio '(touchpad|glidepoint)\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
    declare -i STATE
    STATE=`xinput list-props $ID|grep 'Device Enabled'|awk '{print $4}'`
    if [ $STATE -eq 1 ]; then
    	xinput disable $ID
		if (( IS_QUIET == 0 )); then
    		echo "Touchpad disabled." 
			notify-send 'Touchpad' 'Disabled' -i /usr/share/icons/Adwaita/48x48/devices/input-touchpad.png
		fi
	else
    	xinput enable $ID
		if (( IS_QUIET == 0 )); then
    		echo "Touchpad enabled." 
			notify-send 'Touchpad' 'Enabled' -i /usr/share/icons/Adwaita/48x48/devices/input-touchpad.png
		fi
    # echo "Touchpad enabled."
    # notify-send 'Touchpad' 'Enabled' -i /usr/share/icons/Adwaita/48x48/devices/input-touchpad.png
	fi

}	# ----------  end of function toggle-touchpad  ----------

keyboard-default ()
{
    setxkbmap us
}	# ----------  end of function keyboard-default  ----------
#}}}


################ Misc. Functions{{{

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# A helper to pipe commands into python for immediate interpretation
# TODO: figure out proper way to handle newlines, quotes, and spaces
function pypipe()
{

  python_statements="$1"
  echo "$python_statements" | python
  # for statement in "$@"; do
  #   python_statements="$python_statements$statement\n"
  # done
  # echo "$python_statements" | python
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  view-markup
#   DESCRIPTION:  From https://unix.stackexchange.com/questions/4140/markdown-viewer#120519
#   -- Views any marked up document like *.md as a styled page inside lynx
#   -- Requires pandoc & lynx, potentially python later
#    PARAMETERS: None (for now) | TODO: output options 
#       RETURNS: Opens lynx after piping with pandoc
#-------------------------------------------------------------------------------
view-markup ()
{
    pandoc $1 | lynx -stdin
}	# ----------  end of function view-markup  ----------


  # tmux
  # NOTE: Updated to include '-2' option to force the screen-256color option
  function tma()    { tmux -2 attach -t $1; }
  function tml()    { tmux list-sessions; }
  function tmn()    { tmux -2 new -s $1; }
  function tms()    { tmux -2 switch -t $1; }
  function tmk()    { tmux kill-session -t $1; }
  function tmr()    { tmux rename-session -t $1 $2; }
  function tmlk()   { tmux list-keys; }

# set node permissions to whoami
node-permissions-whoami () {
  sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}
}

# launch steam on arch
function steam-arch {
	LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1 /usr/$LIB/libgpg-error.so' steam
}

#}}}


###
### NVM - Helper functions
###

find-up () {
    path=$(pwd)
    while [[ "$path" != "" && ! -e "$path/$1" ]]; do
        path=${path%/*}
    done
    echo "$path"
}

cdnvm(){
    cd $@;
    nvm_path=$(find-up .nvmrc | tr -d '[:space:]')

    # If there are no .nvmrc file, use the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then

        declare default_version;
        default_version=$(nvm version default);

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [[ $default_version == "N/A" ]]; then
            nvm alias default node;
            default_version=$(nvm version default);
        fi

        # If the current version is not the default version, set it to use the default version
        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default;
        fi

        elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(<"$nvm_path"/.nvmrc)

        # Add the `v` suffix if it does not exists in the .nvmrc file
        if [[ $nvm_version != v* ]]; then
            nvm_version="v""$nvm_version"
        fi

        # If it is not already installed, install it
        if [[ $(nvm ls "$nvm_version" | tr -d '[:space:]') == "N/A" ]]; then
            nvm install "$nvm_version";
        fi

        if [[ $(nvm current) != "$nvm_version" ]]; then
            nvm use "$nvm_version";
        fi
    fi
}

# Only use this alias if nvm is installed, if not it's a waste of time
if hash nvm 2>/dev/null; then
    if [ $bashUseCDNVM -eq 0 ]; then
        # echo "cdnvm in use!"
        alias cd='cdnvm'
    fi
fi



# Disabled Functions (Commented Out){{{

# ssh-agent startup script that checks for a previous running one
#if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#    ssh-agent > $HOME/.ssh-agent-thing
#fi
#if [[ "$SSH_AGENT_PID" == "" ]]; then
#    eval "$(<$HOME/.ssh-agent-thing)"
#fi
#}}}

