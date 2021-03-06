export TERM=xterm-256color
setopt nohup

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export PATH="$HOME/bin:$PATH"
export DEFAULT_USER=brabier

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git python colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Use neovim as default editor or vim as a fallback
if [ -x "$(command -v nvim)" ]; then
  export EDITOR=nvim
elif [ -x "$(command -v vim)" ]; then
  export EDITOR=vim
fi

export VISUAL="$EDITOR"

# Home VCS
alias home='git --work-tree=$HOME --git-dir=$HOME/.home'
alias work='git --work-tree=$HOME --git-dir=$HOME/.work'
alias ll='ls -alh'


# PYTHON
#========
if [ -d "$HOME/.pyenv" ]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  pyenv-install() {
    # Python configuration options close to the Ubuntu ones
    # Checkout out /usr/lib/pythonX.X/config-XX/Makefile
    local MAKE_OPTS="-j4"
    if [[ $OS_NAME == 'Darwin' ]]; then
      local PYTHON_CONFIGURE_OPTS='--disable-dependency-tracking --enable-ipv6 --with-system-expat --with-threads --enable-framework=/System/Library/Frameworks --enable-toolbox-glue --with-system-ffi CC=cc CFLAGS="-arch x86_64 -arch i386 -g -O2 -pipe -fno-common -fno-strict-aliasing -fwrapv -DENABLE_DTRACE -DMACOSX -DNDEBUG -Wall -Wstrict-prototypes -Wshorten-64-to-32" LDFLAGS="-arch x86_64 -arch i386 -Wl,-F."'
    else
      local PYTHON_CONFIGURE_OPTS="--enable-shared --with-fpectl --enable-ipv6 --enable-loadable-sqlite-extensions --with-system-expat --with-system-libmpdec --with-system-ffi CC=x86_64-linux-gnu-gcc CFLAGS=-fstack-protector-strong"
    fi
    pyenv install $*
  }

  pyenv-mkenv() {
    local ENV_NAME=${PWD##*/}
    pyenv virtualenv $1 "$ENV_NAME"
    pyenv local "$ENV_NAME"
    pip install -U pip setuptools wheel
  }
fi

ipykernel-install() {
  pip install ipykernel
  python -m ipykernel install --user --name "$(basename $VIRTUAL_ENV)" 
}

jupyter-notebook() {
  cd ~/notebooks
  nohup jupyter notebook &>/dev/null &
}

# NODE 
#======
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  nvm-update() {
    (
      cd "$NVM_DIR"
      git fetch --tags origin
      git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"
  }
fi

# RUST
#======
if [ -d "$HOME/.cargo" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Scala
#=======
alias scala-cs="TERM=xterm-color scala -Dscala.color"


# Connect to keychain
if [ -x "$(command -v keychain)" ]; then
  for key in $(ls ~/.ssh/id_* | grep -v -F '.pub'); do
    eval `keychain --quiet --nogui --eval $(basename $key)`
  done
fi

# DIRENV
#=======
eval "$(direnv hook zsh)"

