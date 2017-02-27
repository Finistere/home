#!/bin/bash

# Install home git repository
git clone --bare git@github.com:Finistere/home.git .home
cd .home
git remote update

# ZSH
sudo apt-get install zsh

# Oh My ZSH
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"


# Powerline fonts
# cd
# git clone https://github.com/powerline/fonts
# ./fonts/install.sh
# rm -rf fonts

# Terminix
# https://github.com/gnunn1/terminix

