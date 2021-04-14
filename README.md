# Marcus Grant's Bash Dotfiles

This is my repository for my BASH configurations. This is generally a more simple setup because I tend to use ZSH for the machines I interact directly with and BASH as the default for everything else. For this reason this setup needs to be more consistent, stable, and less complex. With one minor caveat, that it uses [bash-it][bash-it] to simply more complex configurations. My old, manually configured, and **very** messy bash configs will be maintained in the `old` branch if you'd like to see them.

## Bash-It

Bash-It is a distribution of bash configurations and scripts that make configuring this arcane shell in a much more manageable way. It's also a massive community so I can be reasonably assured that at least the more popular features are going to be well tested. My biggest concern is that it might be slow on some of the slowest devices I use BASH on, *namely my Raspberry Pi Zeros*. But for now this will be my default configuration.

### Testing Container

This repository has a `Dockerfile` that builds a basic Debian contaienr to test the configurations in. In the `./scripts/` directory there's a script `test-env.sh` that will build the image and interactively run its resulting container with this repositories files pointed to by a bound volume to the Root user's bash dotfiles directory (`/root/.dots/bash`). The docker file creates symlinks for the Root user's `.bashrc` and `.bash_profile` files.

When the `test-env.sh` script is run you end up in the Root user's home, the linked `.bashrc` will look exactly like `bashrc.bash` here and `/root/.dots/bash` will look exactly like this repository and all changes on the developer machine running this container will be reflected there as well.

### How to Use These Dotfiles

Clone this repository into whatever directory is used to store dotfiles.

```sh
mkdir ~/.dots # Where I store my dotfiles
git clone https://github.com/marcus-grant/dots-bash ~/.dots/bash
```

Then just link the `bashrc` & `bash_profile` files to this repository's `bashrc.bash` & `bashprofile.bash` files respectively. *Optionally* you may also want to backup your old config files before doing this.

```sh
mv ~/.bashrc ~/.bashrc.bak
mv ~/.bash_profile ~/.bash_profile.bak
ln -sf ~/.dots/bash/bashrc.bash ~/.bashrc
ln -sf ~/.dots/bash/bashprofile.bash ~/.bash_profile
```

### Install (Bash-It)

This should be done automatically by `.bash_profile`. However, if trying this from a fresh `bashrc` run the container using `scripts/test-env.sh` and run these commands.

```sh
git clone --depth=1 https://github.com/Bash-it/bash-it.git $DOTS_DIR_BASH/bash-it
```

This is what the `bash_profile` will do if it can't detect `BASH_IT` pointing to a directory, *ie the one bash-it normally expects*. `DOTS_DIR_BASH` is an environment variable that is exported early in `bashprofile` and it's the location of the dotfiles directory where


### Basher

This configuration uses [basher][basher] to manage common BASH scripts and helper programs, many of which with plugins that bash-it enhances. The `bash_profile` will check if the folder containing the basher files pointed to by `BASHER_ROOT` is empty. If it is, it will set `BASHER_ROOT` to `$DOTS_DIR/basher`. Then it will clone the files to it. `BASHER_PREFIX` can be used to set a global location like `/opt` or `/usr/local` and basher will install binaries to `$BASHER_PREFIX/bin` and program files to `$BASHER_PREFIX/packages`.

## Links

[bash-it]: https://github.com/Bash-it/bash-it
[basher]: https://github.com/basherpm/basher
