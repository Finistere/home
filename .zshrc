export TERM=xterm-256color
setopt nohup

export PATH="$HOME/bin:$PATH"

# export PS4=$'\e[31m+$(%N:%i)>\e[m'

# emulate sh -c 'source /etc/profile'

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export DEFAULT_USER=brabier

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export OS_NAME=$(uname -s)

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git python colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

# Use neovim as default editor or vim as a fallback
if [ -x "$(command -v nvim)" ]; then
  export EDITOR=nvim
elif [ -x "$(command -v vim)" ]; then
  export EDITOR=vim
fi

export VISUAL="$EDITOR"


# Powerlevel9k
# Searching for the colors ? try `spectrum_ls`
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs virtualenv nvm rust_version)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator time)
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="> "
POWERLEVEL9K_SHORTEN_DIR_LENGTH=100
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_absolute
POWERLEVEL9K_VIRTUALENV_BACKGROUND=0
POWERLEVEL9K_VIRTUALENV_FOREGROUND=6
POWERLEVEL9K_NVM_BACKGROUND=0
POWERLEVEL9K_NVM_FOREGROUND=12
POWERLEVEL9K_RUST_VERSION_BACKGROUND=0
POWERLEVEL9K_RUST_VERSION_FOREGROUND=3

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

# JENV
#======
if [ -d "$HOME/.jenv" ]; then
  eval "$(jenv init -)"
fi

# SDKMAN
#========
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/brabier/.sdkman"
[[ -s "/home/brabier/.sdkman/bin/sdkman-init.sh" ]] && source "/home/brabier/.sdkman/bin/sdkman-init.sh"

# Scala
#=======
if [ -x "$(command -v scala)" ]; then
  alias scala-cs="TERM=xterm-color scala -Dscala.color"
fi

if [ -d "$HOME/vertica" ]; then
  export PATH="$HOME/vertica/vertica-client/bin:$PATH"
fi


# Connect to keychain
if [ -x "$(command -v keychain)" ]; then
  eval `keychain --quiet --eval id_rsa`
fi


