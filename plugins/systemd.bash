# Bash plugin to make life a little easier when dealing with systemd

case $OSTYPE in
    linux*)
        alias sc='systemctl'
        alias scu='sc --user'
        alias scdr='sc daemon-reload'
        alias scdru='scu daemon-reload'
        alias scr='sc restart'
        alias scru='scr --user'
        alias sct='sc stop'
        alias sctu='sct --user'
        alias scs='sc start'
        alias scsu='scs --user'
        # Reordering some of the acronyms
        alias scus='scsu'
        alias scur='scdru'
        alias scut='sctu'
    ;;
esac
