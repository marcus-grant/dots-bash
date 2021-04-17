# Bash prompt using rocketship to speed it up & simplify configuration

# Install starship if not detected
if ! command -v starship &> /dev/null; then
  msg="ATTENTION: BASH prompt uses starship to render itself & it isnt installed!"
  msg="$msg\nInstalling starship now, you'll get a chance to cancel it."
  echo
  echo -e "\e[1;33m$msg\e[0m"
  echo
  echo "NOTE: It's possible to use the basic bash prompt by..."
  echo "...sourcing that prompt file instead withing .bashrc"
  echo
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi

# Indicate the filename (w/o extension) starship will use for configuration
export STARSHIP_CFG_NAME="basic"
# Tell starship to look in the dotfiles directory for its config
export STARSHIP_CONFIG="$DOTS_DIR_BASH/prompts/starship-$STARSHIP_CFG_NAME.toml"

# Init starship
eval "$(starship init bash)"

# Leave behind an alias to update starship occasionally
alias starship-install='curl -fsSL https://starship.rs/install.sh | bash'
alias starship-upgrade='starship-install'
