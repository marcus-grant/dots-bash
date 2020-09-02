TODOs
=====

- [ ] Fix ssh-agent not adding keys 
    - [ ] Also consider not using seperate git & id_rsa keys
- [ ] Fix `PATH` to set home gobin to `~/.local/share/go/bin`
- [ ] Add shadowed `tmux` func that creates a session `main` or opens in it
- [ ] Ensure tmux funcs/alias with `-2` *ie 256color* option doesn't mess with styles
    - This includes less not italicizing highlights instead of bg color change
    - This includes nvim colors particularly in the airlines not mucking up
- [ ] Refactor naming of sub files to use .bash extension
- [ ] Refactor naming of sub files to exclude `bash_*`
- [ ] Try putting the git and id_rsa keychaining conditional block in bash_general in bash_profile instead
- [ ] fif() find-in-file with preview using rg from [this](http://bit.ly/2L7PIhi)
    - Consider adding a function that uses `fif` that uses MY_NOTES_DIR or MY_CODE_DIR
- [ ] Split functions into categorized files
- [ ] Include [`keychain`](https://www.funtoo.org/Keychain) to manage ssh keys once per reboot

Planning
========

- [ ] Add as many of [these](http://bit.ly/2L7PIhi) as possible
- [ ] Figure out how to properly split one time exports into other files
    - .profile seems to be at least one of the correct places
    - .bash_profile then has some complications, investigate
    - It might be faster with all the features I want, do some profiling 1st
- [ ] Make fzf into either an ansible controlled copy or git submodule
- [ ] Figure out how to have `EDITOR` be (n)vim & `VISUAL` be gedit without having terminal apps invoke `VISUAL`


Complete
========

- [x] Make `EDITOR` = nvim or vim instead
- [x] Add fzf.bash as a copy of the junnegun/fzf repo's
- [x] Consider removing go-prompt stuff
- [x] $MY_CODE_DIR export
- [x] Add TODOs.md `5fd9aa2`
