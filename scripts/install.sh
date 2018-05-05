#!/usr/bin/env bash
# Install automatically most of the necessary stuff
# Be sure to add your ssh key to github first

DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)


### CONFIGURATION ###


YAKUAKE=${YAKUAKE:-true}
# .zshrc supposes pyenv to be installed
PYENV=${PYENV:-true}


if [ "$DISTRO" == "Ubuntu" ]; then
  # Strict minimum
  sudo apt-get install zsh curl neovim git fonts-firacode keychain
  
  if [ $YAKUAKE ]; then
    sudo apt-get install yakuake 
  fi

  if [ $PYENV ]; then
    sudo apt-get install python-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
  fi
fi


### Installation ###


# go to home directory
cd

# Use zsh as default shell
chsh -s $(which zsh)

# Oh My ZSH
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Will warn that gruvbox is not installed, just ignore
nvim +PlugInstall +qall

# Powerline fonts
# cd
# git clone https://github.com/powerline/fonts
# ./fonts/install.sh
# rm -rf fonts

# Install home git repository
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

# Pyenv installer
# src: https://github.com/pyenv/pyenv-installer
if [ $PYENV ]; then
  curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
  pyenv update
fi

