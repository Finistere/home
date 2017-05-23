#!/bin/bash

# Install home git repository
git clone --bare git@github.com:Finistere/home.git .home
cd .home
git remote update

# ZSH
sudo apt-get install zsh

# Oh My ZSH
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k


# Powerline fonts
# cd
# git clone https://github.com/powerline/fonts
# ./fonts/install.sh
# rm -rf fonts

# Yakuake Skin
# https://store.kde.org/p/1167641/
# gruvbox: https://store.kde.org/content/show.php/Breeze+Gruvbox+Dark?content=170824

# Konsole (Gruvbox)
# https://github.com/morhetz/gruvbox-contrib/tree/master/konsole
# Env
# TERM=xterm-256color

