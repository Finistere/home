#!/bin/bash
# Zsh AND neovim needs to be installed
# Be sure to add your ssh key to github first
cd

chsh -s $(which zsh) brabier

# Install home git repository
git clone --bare git@github.com:Finistere/home.git .home
git --work-tree=$HOME --git-dir=$HOME/.home remote update
git --work-tree=$HOME --git-dir=$HOME/.home checkout -f master

# Oh My ZSH
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Will warn that gruvbox is not installed, just ignore
nvim +PlugInstall +qall


# Powerline fonts
cd
git clone https://github.com/powerline/fonts
./fonts/install.sh
rm -rf fonts
# Change default font of Konsole as one from powerline

# Yakuake Skin
# https://store.kde.org/p/1167641/
# gruvbox: https://store.kde.org/content/show.php/Breeze+Gruvbox+Dark?content=170824
# Installation: unzip downloaded file; create a .tar; open yakuake configuration and add the skin (.tar file)

# Konsole (Gruvbox)
# https://github.com/morhetz/gruvbox-contrib/tree/master/konsole
# Installation: download gruxbox file, mv to ~/.local/share/konsole/ and edit profile -> appearance
# Env
# TERM=xterm-256color

