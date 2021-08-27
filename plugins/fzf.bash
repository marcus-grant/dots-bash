### FZF Plugin for BASH

# TODO make this more flexible to work with find/ag/etc. if no fd/rg is installed

# TODO remove debug echo's when this works on ubuntu/debian + vim
if command -v fdfind &> /dev/null; then
    export FZF_DEFAULT_COMMAND="/usr/bin/fdfind . --type file --hidden --exclude .git"
elif command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND="fd . --type file --hidden --exclude .git"
fi

fcd () {
    __dir="$(pwd)"
    if [[ $# -gt 0 ]]; then
        __dir="$1"
    fi
    __dir=$(eval "$FZF_DEFAULT_COMMAND $__dir --type directory" | fzf)
    cd $__dir
    # TODO: Find way to exit gracefully if fzf cancelled so no cd command is used
    # if $? ; then
    #     cd $__dir
    # fi
}

fcdh () { # Same as fcd but it only searches from $HOME
    __dir=$(eval "$FZF_DEFAULT_COMMAND $HOME --type directory" | fzf)
    cd $__dir
}

fcdh () { # Same as fcd but it only searches from root
    __dir=$(eval "$FZF_DEFAULT_COMMAND / --type directory" | fzf)
    cd $__dir
}
