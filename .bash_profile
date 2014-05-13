#
# BASH configuration file
#

# Boxen setup and nvm setup.
[[ -f /opt/boxen/env.sh ]] && source /opt/boxen/env.sh

case $(uname) in
Darwin)
  # Find homebrew prefix if it is available.
  brew_prefix=$(brew --prefix)

  # Use (non-Boxen) nvm if possible.
  [[ -f $(brew --prefix nvm)/nvm.sh ]] && source $(brew --prefix nvm)/nvm.sh

  # Enable bash_completion from brew.
  if [ -f $brew_prefix/etc/bash_completion ]; then
    . $brew_prefix/etc/bash_completion
  fi

  # Support for rbenv
  if [ -f $brew_prefix/bin/rbenv ]; then
    eval "$(rbenv init -)"
  fi

  # Put homebrew PHP ahead in $PATH a la http://justinhileman.info/article/reinstalling-php-53-on-mac-os-x/
  export PATH=$brew_prefix/sbin:$brew_prefix/bin:$brew_prefix/share/python:$PATH

  # Terminal coloring
  export CLICOLOR=1

  # Use vim as editor for commits, etc. Recognize if the MacVim app
  # is in ~/Applications, as `brew linkapps` will do.
  EDITOR="/Applications/MacVim.app/Contents/MacOS/Vim"
  [[ -d $HOME/Applications/MacVim.app ]] && EDITOR="${HOME}${EDITOR}"

  export EDITOR="${EDITOR}"
  alias vim=$EDITOR
  alias gvim=mvim

  # EC2 Tools.
  export JAVA_HOME=`/usr/libexec/java_home`

  [[ -d "$HOME/.ec2" ]] && {
    export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
    export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
    export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.3-45758/jars"
    export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.3-62308/jars"
  }

  export PYTHONPATH=$brew_prefix/lib/python2.7/site-packages:$PYTHONPATH

  # NPM
  [[ -d $brew_prefix/lib/node_modules ]] && export NODE_PATH=$brew_prefix/lib/node_modules

  # Support for dvm
  type -p dvm > /dev/null && eval $(dvm env)

  # Paste to private gist.
  alias gaste="pbpaste | gist -p"
  ;;
Linux)
  # Enable bash_completion from brew.
  if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  # Support for rbenv
  type -p rbenv > /dev/null && eval "$(rbenv init -)"

  # Muscle memory is a powerful thing.
  type -P gvim > /dev/null && {
    alias mvim=gvim
  } || {
    alias mvim=vim
  }

  # Set a proper $EDITOR.
  export EDITOR="vim"

  # Colorful ls - I needs it!
  alias ls="ls --color=auto"
  ;;
esac

# Go
export GOPATH=$HOME/Documents/golang
export PATH=$GOPATH/bin:$PATH

# Easy ls -aFl
alias ll="ls -aFl"

# Do you like a colorful grep? I do!
alias grep="grep --color=auto"

alias php-ctags='ctags --langmap=php:.engine.inc.module.theme.php.install.test.profile --php-kinds=cdfi --languages=php --recurse --exclude="\.git" --exclude="\.svn" --exclude="\.hg" --exclude="\.bzr" --exclude="\CVS" --totals=yes --tag-relative=yes --regex-PHP="/abstract\s+class\s+([^ ]+)/\1/c/" --regex-PHP="/interface\s+([^ ]+)/\1/c/" --regex-PHP="/(public\s+|static\s+|abstract\s+|protected\s+|private\s+)function\s+\&?\s*([^ (]+)/\2/f/"'

# Easy bundle exec'ing.
alias be="bundle exec"

# If PEAR is installed, put its bin dir ahead of $PATH.
type -P pear > /dev/null && export PATH=$(pear config-get bin_dir):$PATH

# Always set up $HOME/bin in $PATH.
export PATH=$PATH:$HOME/bin

# Wrap 'git' in 'hub' if it is available.
type -P hub > /dev/null && {
  alias git=hub
}

# Use keychain if it's available.
type -P keychain > /dev/null && eval `keychain --eval --agents ssh id_rsa id_dsa`

# Load other files for bash's use, including some that may not be in git.
[[ -d ~/.profile.d ]] && for i in ~/.profile.d/*; do
  source $i
done

# Load up tmuxinator if it's available.
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# CLJR for Clojure.
[[ -d $HOME/.cljr/bin ]] && export PATH=$HOME/.cljr/bin:$PATH

# If we are in an interactive session, source bashrc.
[[ -n $PS1 && -f ~/.bashrc ]] && . ~/.bashrc

type -P phpenv > /dev/null && {
  export PATH="$HOME/.phpenv/bin:$PATH"
  eval "$(phpenv init -)"
}

# Keep Packer's cache in one place.
export PACKER_CACHE_DIR="$HOME/Downloads/packer_cache"

true
