export ASDF_CONFIG_DIR="$HOME/.config/asdf"
export ASDF_CONFIG_FILE="$ASDF_CONFIG_DIR/asdfrc"
export ASDF_DIR="$HOME/.local/share/asdf"
export ASDF_DATA_DIR=$ASDF_DIR

if [ ! -d "$ASDF_CONFIG_DIR" ]; then
    mkdir -p $ASDF_CONFIG_DIR
fi
if [ ! -d "$ASDF_DIR" ]; then
    mkdir -p $ASDF_DIR
fi

# Contains completions and script references
if [ -e "$ASDF_DATA_DIR/asdf.sh" ]; then
    source $ASDF_DATA_DIR/asdf.sh
fi
