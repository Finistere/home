#!/bin/bash
# Ensure that zsh AND nvim are installed before launching the script
cd

chsh -s $(which zsh) brabier

# Install home git repository
git clone --bare git@github.com:Finistere/home.git .home
git --work-tree=$HOME --git-dir=$HOME/.home checkout remote update
git --work-tree=$HOME --git-dir=$HOME/.home checkout -f master

# Oh My ZSH
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall +qall


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

