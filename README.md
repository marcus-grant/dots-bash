# MyBASH

This is my repository to store my personal bash configurations. They are divided into different files so it is easier to maintain different versions. They are also stored in ~/SHELL/mybash/ so that git can work properly, and they are sourced in .bash_profile and .bashrc by single line references so that they reference whatever version I'd like. There will be a write up for my blog for how I set this config up, how I use it, and why coming shortly, and its contents will be here and on my [personal site/blog](http://thepatternbuffer.com).

## Files
*heavily inspired by* [alrra/dotfiles](https://github.com/alrra/dotfiles)
This bash configuration seperates all of the configurations into different files based on the context:
- [x] `bash_profile`: the entry point for the login shell
- [x] `bashrc`: the standard entry point for non-login shell
- [x] `bash_exports`: custom dotfile that has all of bash's exports
- [x] `bash_aliases`: custom file that has all bash aliases as called by bashrc
- [x] `bash_functions`: custom file that has all bash functions called by bashrc
- [ ] `bash_options`: `shopt` tweaks to the shell, look at alrra/dotfiles for ideas

The `bash_profile` will only source `bash_exports` to load in all global variables needed that are customized for this configuration. Then in `bashrc` `bash_aliases`, `bash_functions`, `bash_general` & `bash_options` get sourced to create the proper non-login shell so that it's easier to manage all the numerous customizations this configuration has. On top of those sources listed, `bashrc` will also source a symlink, `prompt-link` which will point to the right script file inside of `./prompts` to use one of several different prompt options.


## Prompts


## Aliases


## Functions
- FZF since it just uses STDIN/OUT is amazing at searching, particularly when combined with an even better `fd` command to use instead of find
### FZF
```sh
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
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
```
- and in `bash_exports` there are default commands that allow pressing CTRL+T & ALT+C to apped to the terminal directories to be used in commands and to cd to
- by adding a `.gitignore` with directories in the root to ignore, it's possible to ignore some files 


## TODO
***Note*** *many other todos have been completed, but only recently have they been getting tracked inside this README*
- [x] add *golang* version of powerline prompt for better latency
- [x] fix `choose-prompt.sh` to handle all edge cases and to be more readable
- [ ] fzf integrations
  - [ ] improvements to fd
  - [ ] default options as exports
- [ ] add git autocomplete, [here](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash) is one possible solution
- [ ] include old README stuff that's valid here, but move all instructional stuff to dev-notes, and delete the rest
- [ ] add grep colors support based off [alrra/dotfiles](https://github.com/alrra/dotfiles/tree/master/src/shell/colors)
- [ ] add autocomplete functionality based off [alrra/dotfiles](https://github.com/alrra/dotfiles/tree/master/src/shell/autocomplete)
- [ ] add bash options into `bash_options.sh` based off [alrra/dotfiles](https://github.com/alrra/dotfiles/blob/master/src/shell/bash_options)


## Change History
- **History starts @ 2017 - 11 - 12** Lots of work has been done previously however
- **2017 - 11 - 12:** Restructure all configs to be more organized
  - `bash_exports`, `bash_aliases`, `bash_functions`, `bash_options` & `bash_general` have been created to seperate 
  - `MACHINE` variable now is exported based off which host OS this is run from
    - This is important for several exports, aliases, & functions that will be different due to host OS type
  - `BASH_CONFIGS_ROOT` variable now gets defined in `bash_profile` to make getting config paths easier
  - `prompts/` now has all prompt configs including submodules for more complex dynamic prompts
  - `prepare.sh` refactor & default prompt linking
    - Refactored so that every task is now a forward defined function
    - Refactored variable names so they're more readable, `*_SRC` is now an original file to be linked & `*_DST` is now for links
    - Now creates `prompt-link` so that it links to `bash-powerline` submodule as the default prompt since it's guaranteed to work fast on any UNIX system since it's entirely a bash script
- **2017 - 11 - 13:** powerline-go
  - Install [justjanne/powerline-go](https://github.com/justjanne/powerline-go)
  - `prompts/go-prompt.sh` now uses options inside `prompts/go-prompt-options.sh` to create a go-based powerline prompt
  - `prompts/go-prompt-options.sh` has a nicely commented set of variables containing all possible `powerline-go` options which are then included in `PROMPT_OPTS` within the file to include as many or few options to customize the powerline
  - `.gitignore` now ignores the `prompts/prompt-link` so it doesn't change the local prompt
  - `prompts/powerline-go` is the binary for launching go, which has to be included in `GOPATH` variable
    - this also means that `prompts/powerline-go` needs to be downloaded manually to be used
  - `bash_exports` now has improved `PATH`, `GOPATH` & `GOBIN` which makes `powerline-go` work and makes managing go projects easier
    - *i.e.* they're all inside `~/bin/go`
  - Complete rewrite of `prompts/choose-prompt.sh` since not all edge cases were addressed
  - Also rewrite `prompts/choose-prompt.sh` because it was hard to alter (spaghetti code) and to make it more readable (forward declaration)
  - Fix bugs in `prepare.sh`
    - `prepare.sh` would fail to link `.bashrc` and `.bash_profile` if they already exist due to race condition, no more
    - new hosts/users wouldn't have submodules needed for prompt downloaded, script now updates submodules
    - new hosts/users wouldn't be able use new `.bashrc` because `.bash_profile` sets the `BASH_CONFIGS_ROOT` var it needs to source partial config files
  - Fix `bashrc` bugs
    - add export for `BASH_CONFIGS_ROOT` since it is needed for situations where bashrc gets called before `bash_profile` not sure why that would happen but it seems to fix it
  - Fix bug with `bash_aliases.sh` where a unary operator error would be printed due to poor syntax on the `MACHINE` assignemtn if block
- **2018 - 02 - 17** FZF & Folds
  - FZF exports & functions
  - folding marks are now in use in some files
  - `aliases`
    - file has been reorganized with vim fold marks
    - also `scl` now works as the shortcut to `sudo systemctl`
    - `pacman` now replaces the real pacman with `sudo pacman --color always`
    - `l` is now for nonhidden files
    - `la` is roughly same as before, as many details as possible
    - `lt` is `la` but sorted by time & reversed so new is near prompt
    - `lS` is `lt` except it sorts by size & reversed so large near prompt
- **2018 - 02 - 18** Migrating **all** dotfile folders into the `dotfiles` repo


# OLD VERSION, KEEP WHAT IS USEFUL IN REWRITE DELETE REST
Whenever this repository is being used for the first time, a few things will need to be done first:
1. Run `git clone https://github.com/marcus-grant/mybash` in your `~/` directory, aka, your home
2. Clear .bashrc and paste this into it and save:
```
	if [ -f ~/Shell/mybash/.bashrc ]; then
		source ~/Shell/mybash/.bashrc
	fi

```
3. Do the same for `~/.bash_profile` with this:
```
	if [ -f ~/Shell/mybash/.bash_profile ]; then
		source ~/Shell/mybash/.bash_profile
	fi
``` 
**TODO: create a simple shell script that takes care of this to simplify install**

# Prompt Configuration
The prompt is what you see on the left-most side of every open command line, it is there originally to show you what user you are currently logged in or aliased as on the system, and it shows you under which hostname you are operating on, which is very useful when you telnet or ssh into a system to manage it. In this case we are going to add some more info, like the timestamp for when the prompt was written, to help track time, the git branch you are on if there is one in your current directory, the current directory, and we will style it to my liking. To do this, add the lines below to your `.bashrc`.
```
  # This function is called in your prompt to output your active git branch.
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }
```
This is a helper function to help parse out if there is a .git folder present in the current directory, and if there is one, get the name of the branch that is currently active on that git folder.

```
  # This function builds your prompt. It is called below
  function prompt {
    # Define some local colors
    local         RED="\[\033[0;31m\]" # This syntax is some weird bash color thing I never
    local   LIGHT_RED="\[\033[1;31m\]" # really understood
    local        CHAR="♥"
    local   BLUE="\[\e[0;49;34m\]"

    # ♥ ☆ - Keeping some cool ASCII Characters for reference

    # Here is where we actually export the PS1 Variable which stores the text for your prompt
    export PS1="\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]$RED\$(parse_git_branch) \[\e[32m\]\W\[\e[0m\]\n\[\e[0;31m\]$BLUE//$RED $CHAR \[\e[0m\]"
      PS2='> '
      PS4='+ ' 
    }
```
Here is a function that actually does the job of configuring the prompt. There are local variables that define colors and characters used in that prompt, because as you can see in the export statement (the statement that configures the bash prompt) has very unwieldy syntax that I can never remember no matter how hard I try, kudos you glorious master-race neckbeards. If you need to configure the prompt in any other way, it's best to lookup code snippets online that help create specific parts of the prompt that you might like, the link that's in the file is where I drew my inspiration, and that is the snippet I hunted for to modify in helping creating this prompt. Isolating definitions and bash calls into function as I did makes it MUCH easier to quickly and easily modify certain parts of the prompt definition, and honestly, it should probably be broken up even further with local definitions for formatting each individual part of the prompt definition, such as the formatting for the timestamp, or whatever else.
```
  # Finally call the function and our prompt is all pretty
  prompt
```
And then of course, because we created this helper function to layout the prompt, that function needs to actually be called to be of any use.

# Environmental Variables & Paths
** This entire section requires rework because it came from a macOS .bash_profile **

# Helper Functions
Here is where there are several helpful bash functions defined to make life on BASH easier.
```
function desktop {
  cd /Users/$USER/Desktop/$@
}
```
Here is a function that helps you take your terminal right to the current user's `~/Desktop/` folder wherever you may currently be. Simply type `desktop` into your prompt.

```
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
```
This snippet I particularly love. I wish I could remember where I got it from, but if anyone knows, do please chime in, in the comments or issues section, and I will gladly give credit where credit is due. But anyways, what this function `extract` does, is simplify the process of extracting files/directories from a compressed file/archive. How it works, is that it creates a switch statement that checks for the suffix of the file for different common file extensions for compressed files. Then it puts out the proper terminal command to extract that file into the current working directory. To use; simply go to the folder you want to extract to, and type `extract FILE_PATH` and replace *FILE_PATH* with the path and filename of the compressed file you want extracted there.

# Aliases
Here is the section where I keep all of my various aliases that either replace common bash commands, with parameter calls that I think should be the default, or create new commands using the alias command to make terminal work easier. Aliases are easily defined in BASH. Simply type `alias ALIAS_NAME='ALIAS_COMMAND'` where you replace *ALIAS_NAME* with the command you type to execute the alias, and *ALIAS_COMMAND* is the same command that you would normally type into the terminal.
  
```
  alias dev='cd ~/Dropbox/Dev'
  alias ios='cd ~/Dropbox/Dev/iOS'
```
These aliases define shortcut commands that help me get to my various development environments quickly.

```
  alias oxw='open *.xcw*'
  alias oxp='open *.xcod*'
```
Here I define aliases that are shortcuts for opening a file with a particular application, or simply open the application without any starter file.


```
  alias l='ls -lahG'
  alias ls='ls -G'
  alias ll='ls -laG'
```
These aliases are all based around the `ls` command. I **HATE** that the default BASH directory lookup command is color-less, and so I replace the command `ls` with the alias `alias ls='ls -G'` so that I always get colored results when I try and look at the files and folders within a directory. There are also other shortcuts that I frequently use to make life easier.

```
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
  alias gbb="git branch -b"
```
Git commands can get arduous because you'll find yourself typing `git` a whole lot. Why not make them shortcuts to get through git management a little bit easilier? I don't think it's a good idea however, to replace any git commands with overwritting aliases, because there's a lot of critical functionality present in some of the original commands.

```
  bind "set completion-ignore-case on" 
```
I prefer to make file and directory search case-insensitive, so this binding makes all file or directory statements case-insensitive. Comment out, if you'd prefer to leave it the standard way.

# Final Configurations & Plugins
** TODO: This is OS specific and needs an audit **
Here I keep a grab-bag of configs and plugins that 
```
########
#
# 5. Final Configurations & Plugins
#
########
  # Git Bash Completion
  # Will activate bash git completion if installed
  # via homebrew on macOS, or whatever linux package manager you use
  # NEEDS UPDATING TO WORK ON BOTH macOS & various Linux carnations
  #if [ -f `brew --prefix`/etc/bash_completion ]; then
  #  . `brew --prefix`/etc/bash_completion
  #fi

  # RVM - NEEDS AUDITING
  # Mandatory loading of RVM into the shell
  # This must be the last line of your bash_profile always
  #[[ -s "/Users/$USER/.rvm/scripts/rvm" ]] && source "/Users/$USER/.rvm/scripts/rvm"  # This loads RVM into a shell session.
```





