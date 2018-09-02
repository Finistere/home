#!/usr/bin/env bash
# Install automatically most of the necessary stuff
# Be sure to add your ssh key to github first
set -e

DISTRO=$(awk -F= '/^NAME/{gsub(/"/, "", $2); print $2}' /etc/os-release)


# Configuration
#===============

PACKAGES_INSTALLATION=${PACKAGES_INSTALLATION:-false}
YAKUAKE=${YAKUAKE:-true}
PYENV=${PYENV:-true}
NVM=${NVM:-true}


# System Packages
#=================

if [ $PACKAGES_INSTALLATION = true ]; then
  if [ $DISTRO = 'Ubuntu' ]; then
    echo "Minimal Installation"
    # Strict minimum
    sudo apt-get install zsh curl neovim git fonts-firacode keychain

    if [ "$YAKUAKE" = true ]; then
      echo "Installing Yakuake"
      sudo apt-get install yakuake 
    fi

    if [ "$PYENV" = true ]; then
      echo "Installing Pyenv"
      sudo apt-get install python3-dev python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev
    fi
  fi
fi


# Custom Installation
#=====================

# go to home directory
cd

# Zsh
#-----
if [ -x "$(command -v zsh)" ]; then
  # Use zsh as default shell
  chsh -s $(which zsh)

  # Oh My ZSH
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

  # Powerlevel9k
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi

# Nvim
#------
if [ -x "$(command -v nvim)" ]; then
  # Vim-plug
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Will warn that gruvbox is not installed, just ignore
  nvim +PlugInstall +qall
fi

# Powerline fonts
# cd
# git clone https://github.com/powerline/fonts
# ./fonts/install.sh
# rm -rf fonts

# Home
#------
git clone --bare git@github.com:Finistere/home.git .home
git --work-tree=$HOME --git-dir=$HOME/.home remote update
git --work-tree=$HOME --git-dir=$HOME/.home checkout -f master

# Change default font of Konsole as one from powerline

echo "Yakuake & Konsole skins/profile are preinstalled, you only have to select them if necesary"

# Yakuake Skin
# https://store.kde.org/p/1167641/
# gruvbox: https://store.kde.org/content/show.php/Breeze+Gruvbox+Dark?content=170824
# Installation: unzip downloaded file; create a .tar; open yakuake configuration and add the skin (.tar file)

# Konsole (Gruvbox)
# https://github.com/morhetz/gruvbox-contrib/tree/master/konsole
# Installation: download gruxbox file, mv to ~/.local/share/konsole/ (konsole) AND .kde/share/apps/konsole (yakuake) and edit profile -> appearance
# Env
# TERM=xterm-256color

# Pyenv
#-------
if [ "$PYENV" = true ]; then
  # https://github.com/pyenv/pyenv
  curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
  pyenv update
fi

# Nvm
#-----
if [ "$NVM" = true ]; then
  # https://github.com/creationix/nvm
  export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/creationix/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  ) && \. "$NVM_DIR/nvm.sh"
fi

