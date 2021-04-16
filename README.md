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

## Using Bash-It & Oh My ZSH as Templates NOT As Distributions

After using Bash-It for a while I've determined it's just not for me, at least Bash-It in Bash. For one Bash-It doesn't support persisting its setup through configuration files. To enable completions, aliases and plugins you have to interact with it through the CLI. I use ansible to automate setups so this is already a non-starter. Also the distribution is massive, I honestly wish I didn't include it into the git graph, but it's not the end of the world. Instead I'll be using it for a template to follow.

I've also decided the three principle I want in v3:

- Simplicity
  - Keep it simple, this isn't a shell I'll be using on my every day interactive machines, this will mostly go on servers, mobile devices, and IoT devices like Pis. It needs to be easily configured and fixed when problems arise
- Reliability
  - Along with simplicity comes reliability, simplicity is more reliable. But as a principle on its own, since servers will use this configuration they need to be reasonably assured they'll run without problems.
- Speed
  - Because embedded and mobile devices will use this configuration it's very important that speed isn't an issue. Espeically important with `git status` being used in prompts. Pi Zeroes can take entire seconds to draw the prompt. Even though selectors in the configuration makes it less simple this is one area where it should be considered.
- Conformity
  - One of the things I like about Bash-It & Oh-My-ZSH is that they follow community best practices for naming, command conventions and best practices. When copying over functionality try and follow these public conventions as closely as possible.

Once I'm reasonably sure I've tried all the plugins, completions and plugins and then written them into this dotfile set, I'll probably move on to version 4 of my dotfiles and purge Bash-It and Basher from my git history.

## Aliases

One of the most important uses for a custom shell is having useful shorthands for common commands that can get tedious to type out in full. Here is a section of these aliases that get used. Warning, may not be exhaustive.

### General Aliases

These are the generic system aliases with no dependencies. It will also attempt to set `ls colors` dependant on the host system. MacOS for example uses `ls -G` over `ls --color=auto` instead.

| Alias | Command | Description |
--- | --- | --- |
| l | ls -a | A compact directory view, `-a` **all** types of file/dir references |
| la | ls -AF | Compact directory view, `-A` for **all except implied . ..** and `-F` to **append filetype indicator**. No symbol = file, `/` for dirs, `@` for symlinks, etc. |
| l1 | ls -1 | Shows exactly what `ls` shows, but **1** per line as a list without extra info |
| ll | ls -ahl | Shows **all** (`a`) in **human-readable** form (`h`) as a **list** (`l`) |
| lt | ll -t | Same as `ll` but sorted by time, newest first |
| ltr | lt -r | Same as `lt` but reverse order, oldest first |
| lz | ll -S | Same as `ll` but sorted by si`z`e, largest first |
| lzr | lz -r | Same as `lz` but reverse order, smallest first |
| _ | sudo | A **really** short way to type `sudo` |
| edit | $EDITOR | Edits with the default editor defined in `EDITOR` environment variable|
| ebrc | edit ~/.bashrc | Edit the bash config with default `EDITOR` |
| ebpf | $edit ~/.bash_profile | Edit the bash profile with default `EDITOR` |
| rbrc | source ~/.basrc; | Reload bash configs, useful for editing configurations |
| grep | grep --color=auto | Default to automatic grep coloring, gets checked against host ability for color |
| grepc | grep --color=always | Force grep to use colors, programs need to know it's colored  so it's its own alias |
| grepl | grep $@ \| less | Uses a condition to check for color and pipes grep to less |
| q | exit | Shorthand for exiting the current shell |
| py | python3 or python | Shorthand for python3 if it exists otherwise python |
| ipy | ipython3 or python | Same as `py` but referencing ipython3 or ipython |
| pip | pip3 | Overrides `pip3` if it exists, otherwise it does nothing |
| rb | ruby | Shorthand for ruby |

## Links

[bash-it]: https://github.com/Bash-it/bash-it
[basher]: https://github.com/basherpm/basher
