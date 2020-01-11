TODOs
=====


Current
-------

- [ ] Edit prompt to truncate path to single character till prompt fits
- [ ] Edit prompt to hide `$user@host` if...
    - path is too long to fit deepest directory
    - **NOT** on remote or root user
- [ ] Edit prompt to highlight root user as red if root
- [ ] Edit prompt to highlight host as CYAN/MAGENTA/PURPLE if remote
- [ ] Try putting the git and id_rsa keychaining conditional block in bash_general in bash_profile instead
- [ ] fif() find-in-file with preview using rg from [this](http://bit.ly/2L7PIhi)
    - Consider adding a function that uses `fif` that uses MY_NOTES_DIR or MY_CODE_DIR
- [ ] Split functions into categorized files
- [ ] Include [`keychain`](https://www.funtoo.org/Keychain) to manage ssh keys once per reboot
- [ ] Refactor naming of sub files to use .bash extension
- [ ] Refactor naming of sub files to exclude `bash_*`
- [ ] Add 


Planning
--------

- [ ] Add as many of [these](http://bit.ly/2L7PIhi) as possible
- [ ] Figure out how to properly split one time exports into other files
    - .profile seems to be at least one of the correct places
    - .bash_profile then has some complications, investigate
    - It might be faster with all the features I want, do some profiling 1st
- [ ] Make fzf into either an ansible controlled copy or git submodule
- [ ] Figure out how to have `EDITOR` be (n)vim & `VISUAL` be gedit without having terminal apps invoke `VISUAL`
- [ ] **IS THIS STILL AN ISSUE?** Ensure tmux funcs/alias with `-2` *ie 256color* option doesn't mess with styles
    - This includes less not italicizing highlights instead of bg color change
    - This includes nvim colors particularly in the airlines not mucking up


Complete
--------

- [x] Add shadowed `tmux` func that creates a session `main` or opens in it
- [x] Fix `PATH` to set home gobin to `~/.local/share/go/bin`
- [x] Make `EDITOR` = nvim or vim instead
- [x] Add fzf.bash as a copy of the junnegun/fzf repo's
- [x] Consider removing go-prompt stuff
- [x] $MY_CODE_DIR export
- [x] Add TODOs.md `5fd9aa2`
