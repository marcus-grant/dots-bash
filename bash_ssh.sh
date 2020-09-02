# Bash Profile Helper Config File for Managing SSH Passwords
# Marcus Grant 2020 Sept.
# This stack exchange has some great alternatives: https://bit.ly/2YYHmOv

if [ ! -S $HOME/.ssh/ssh_auth_sock ]; then
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" $HOME/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
if [ -f $HOME/.ssh/git.key ]; then
    ssh-add -l > /dev/null || ssh-add $HOME/.ssh/git.key
fi

if [ -f $HOME/.ssh/id_rsa ]; then
    ssh-add -l > /dev/null || ssh-add $HOME/.ssh/id_rsa
fi
