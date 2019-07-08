########

# some functions need to know the host OS type, and the only argument to this script
# will be stored as variable 'machine'
machine=$1

t_error="[ERROR]:"

# TODO orphan, find home
git-set-key() { eval $(ssh-agent); local keyPath="$HOME/.ssh/git.key"; ssh-add "$keyPath"; }

################ FZF, RipGrep, etc. Functions{{{

# fdorfind - will use fd if available, else use find using fd syntax
fdorfind() {
    # get args for commands to be used, ignoring greater than 2
    # also set the default blanks for any of them beeing missing
    searchPattern="$1"
    searchPath="$2"
    if [ $# -lt 2 ]; then
        searchPath="./"
    fi
    if [ $# -lt 1 ]; then
        searchPattern="."
    fi

    # handle the case (only used by other funcs) where >= 3 args used
    # the args above 2 will be actual fd (only) args/opts
    local otherArgs=""
    local argIter=1
    if [ $# -gt 2 ]; then
        for arg in "$@"
        do
            if [ $argIter -gt 2 ]; then
                otherArgs="$otherArgs $arg"
            fi
            argIter=$((argIter + 1))
        done
    fi

    # Check if fd is present, use 'find' instead if not
    if command -v fd >/dev/null; then
        searchCommand="fd $searchPattern $searchPath $otherArgs -H -E *.git*"
        # fd "$searchPattern" "$searchPath" -H -E *.git* | fzf
        # fd "$searchPattern $searchPath" | fzf
    else
        # find "$searchPattern" "$searchPath" -type f | fzf
        # find "$searchPattern $searchPath" -type f | fzf
        searchCommand="find $searchPattern $searchPath $otherArgs -type f"
    fi
    eval $searchCommand
    # echo "COMMAND: $searchCommand"
    # TODO : should this have an exit code?
}

# same as fdorfind but only fir dirs - really only used as a helper
fdorfinddir() {
    # get args for commands to be used, ignoring greater than 2
    # also set the default blanks for any of them beeing missing
    searchPattern="$1"
    searchPath="$2"
    if [ $# -lt 2 ]; then
        searchPath="./"
    fi
    if [ $# -lt 1 ]; then
        searchPattern="."
    fi

    # Check if fd is present, use 'find' instead if not
    if command -v fd >/dev/null; then
        searchCommand="fd $searchPattern $searchPath -H  -E *.git* -t d"
        # fd "$searchPattern" "$searchPath" -H -E *.git* | fzf
        # fd "$searchPattern $searchPath" | fzf
    else
        # find "$searchPattern" "$searchPath" -type f | fzf
        # find "$searchPattern $searchPath" -type f | fzf
        searchCommand="find $searchPattern $searchPath -type d"
    fi
    eval $searchCommand
    # echo "COMMAND: $searchCommand"
    # TODO : should this have an exit code?
}

# use fd to quickly search
function fdf() {
    fdorfind $@ | fzf
}

# same as fdf but for directories only
fdfd() {
    fdorfinddir $@ | fzf
}

# uses rg to search a string in a directory's files fzf filters out one
#  - pattern [path] as rg are the args
#  - if a path is given it will go to that directory and run rg PATTERN
#    - this is to give clean output for fzf to parse through (colors)
#    - once done it will return to where this function was called
rgf() {
    # no args is an error
    if [ $# -le 0 ]; then
        rg
    # 2+ args means 2nd arg gets used to cd to that location
    elif [ $# -ge 2 ]; then
        if [ ! -d "$2" ]; then
            echo "$2: No such file or directory"
            return 1
        fi
        local initDir="$(pwd)"
        cd $2
        echo "$(rg --color always $1 | fzf --ansi)"
        cd $initDir
    else
        echo "$(rg --color always $1 | fzf --ansi)"
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


# cd with an fdfd ( fd or find | fzf ) directory search
fcd() {
  local dir
  local destDir="$(fdfd $@)"
  cd "$destDir"
}

# use fd & fzf to find a file to edit (only arg is an optional root dir)
# TODO consider moving to better section
editfile() {
    # if there's more than one arg it's a special case where we
    # pass on all arguments to fdf
    if [ $# -gt 1 ]; then
        local editfilepath="$(fdf . $@)"
    else
        # handle the args only arg is root directory to look/create file
        local rootDir="./"
        if [ ! -z $1 ]; then rootDir="$1"; fi
        # use fdf which uses either fd or find then fzf to find a directory
        local editfilepath="$(fdf . $rootDir)"
    fi
    if [ -z $editfilepath ]; then return 1; fi
    echo "Editing $editfilepath"
    # then use $EDITOR to create a new file with the prompted filename
    $EDITOR $editfilepath
}

# use fd & fzf to find using fuzzy search a directory to open 
# TODO consider moving it into its a better section
editfiled() {
    # handle the args only arg is root directory to look/create file
    local rootDir="./"
    if [ ! -z $1 ]; then rootDir="$1"; fi
    # save current location to return to once done
    local initDir="$(pwd)"
    # use fdfd which uses either fd or find then fzf to find a directory
    local dir="$(fdfd . $rootDir)"
    # in case you cancel out of the search exit this function cleanly
    if [ ! -z $dir ]; then
        # then prompt the user for a filename to placed in that directory
        echo
        echo "    Enter filename:"
        read -p "    $dir/" newfilename
        echo
        # move to that directory
        cd $dir
        # then use $EDITOR to create a new file with the prompted filename
        $EDITOR $newfilename
        # return back to the initial call of this location's path
        cd $initDir
    fi
}

# use rg & fzf to find a file to edit (only arg is an optional root dir)
# TODO consider moving to better section
editfilerg() {
    local searchPath=""
    # rgf/rg won't work without at least one arg
    # call rg to show the expected error if it was entered into rg
    # then return
    if [ $# -le 0 ]; then rg; return 1; fi
    # if there's a 2nd arg and it's not a path, things will break, exit w/ err
    if [ $# -ge 2 ]; then
        searchPath="$2"
        # it's possible the last char is '/', that'll break stuff, cut it out
        if [ "${searchPath: -1}" == "/" ]; then
            searchPath="${searchPath::-1}"
        fi
        if [ ! -d $searchPath ]; then
            echo "$searchPath: $(text-color red "No such file or directory")"
            return 1
        fi
    fi
    # use rgf to return a file and the line of the search pattern
    # cut is used to only get the file path
    local editfilepath="$(rgf $@ | cut -f1 -d":")"
    if [ -z $editfilepath ]; then return 1; fi
    # if a path was given as a root for the search, it has to be prepended
    if [ $# -ge 2 ]; then editfilepath="$searchPath/$editfilepath"; fi
    # then use $EDITOR to create a new file with the prompted filename
    echo "Editing $editfilepath"
    $EDITOR $editfilepath
}

# use editfile() in notes directory only
# TODO consider other location for this func
notedit() {
    local searchPath="$MY_NOTES_DIR"
    # if 2nd arg exists it's assumed as a path append to MY_NOTES_DIR
    if [ $# -ge 1 ]; then searchPath="$searchPath/$1"; fi
    # make sure there's no trailing '/'
    if [ "${searchPath:-1}" == "/" ]; then searchPath="${searchPath::-1}"; fi
    # append args for fd having to do with only including extensions like these
    local searchFileExts="-e txt -e rst -e rtf -e html -e tex -e md"
    editfile $searchPath $searchFileExts
}

# uses editfilerg() PATTERN [PATH (appended to MY_NOTES_DIR)]
noteditrg() {
    local searchPattern=""
    local searchPath="$MY_NOTES_DIR"
    # append to search pattern if $1 exists
    if [ ! -z $1 ]; then searchPattern="$1"; fi
    # append to MY_NOTES_DIR if $2 exists
    if [ ! -z $2 ]; then searchPath="$searchPath/$2"; fi
    # make sure that the searchPath doesn't have trailing '/'
    if [ "${searchPath:-1}" == "/" ]; then searchPath="${searchPath::-1}"; fi
    # call editfiled
    editfilerg $searchPattern $searchPath
}

# uses editfiled to create new file by fd (dir only) | fzf then opens editor on it
notenew() {
    local searchPath="$MY_NOTES_DIR"
    # only arg is prepending MY_NOTES_DIR 's path
    if [ -z $1 ]; then searchPath="$searchPath/$1"; fi
    # make sure there's no trailing '/'
    if [ "${searchPath:-1}" == "/" ]; then searchPath="${searchPath::-1}"; fi
    editfiled $searchPath
}


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

# launch steam on arch
function steam-arch {
	LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1 /usr/$LIB/libgpg-error.so' steam
}

#}}}


################ Misc. Functions{{{

# colors text based on a string red/green/blue/yellow/magenta/cyan
text-color() {
    local colorString=""
    local inputString=""
    if [ $# -ge 2 ]; then inputString=$2; fi
    local resetString="\e[0m"
    case "$1" in
        red)
            colorString="\e[31m"
            ;;
        green)
            colorString="\e[32m"
            ;;
        yellow)
            colorString="\e[33m"
            ;;
        blue)
            colorString="\e[34m"
            ;;
        magenta)
            colorString="\e[35m"
            ;;
        cyan)
            colorString="\e[36m"
            ;;
    esac
    echo -e "$colorString$inputString\e[0m"
}
################ }}}


################ NVM Helpers {{{

# TODO this is causing too many problems, disabling for now
# find-up () {
#     path=$(pwd)
#     while [[ "$path" != "" && ! -e "$path/$1" ]]; do
#         path=${path%/*}
#     done
#     echo "$path"
# }
#
# cdnvm(){
#     cd $@;
#     nvm_path=$(find-up .nvmrc | tr -d '[:space:]')
#
#     # If there are no .nvmrc file, use the default nvm version
#     if [[ ! $nvm_path = *[^[:space:]]* ]]; then
#
#         declare default_version;
#         default_version=$(nvm version default);
#
#         # If there is no default version, set it to `node`
#         # This will use the latest version on your machine
#         if [[ $default_version == "N/A" ]]; then
#             nvm alias default node;
#             default_version=$(nvm version default);
#         fi
#
#         # If the current version is not the default version, set it to use the default version
#         if [[ $(nvm current) != "$default_version" ]]; then
#             nvm use default;
#         fi
#
#         elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
#         declare nvm_version
#         nvm_version=$(<"$nvm_path"/.nvmrc)
#
#         # Add the `v` suffix if it does not exists in the .nvmrc file
#         if [[ $nvm_version != v* ]]; then
#             nvm_version="v""$nvm_version"
#         fi
#
#         # If it is not already installed, install it
#         if [[ $(nvm ls "$nvm_version" | tr -d '[:space:]') == "N/A" ]]; then
#             nvm install "$nvm_version";
#         fi
#
#         if [[ $(nvm current) != "$nvm_version" ]]; then
#             nvm use "$nvm_version";
#         fi
#     fi
# }
#
# # Only use this alias if nvm is installed, if not it's a waste of time
# if hash nvim 2>/dev/null; then
#     alias cd='cdnvm'
# fi



# Disabled Functions (Commented Out){{{

# ssh-agent startup script that checks for a previous running one
#if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#    ssh-agent > $HOME/.ssh-agent-thing
#fi
#if [[ "$SSH_AGENT_PID" == "" ]]; then
#    eval "$(<$HOME/.ssh-agent-thing)"
#fi
#}}}

