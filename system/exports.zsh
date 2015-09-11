export EDITOR='brackets'

# PATHS
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$PATH:~/bin
export PATH=/usr/local/mongodb/2.6.4/bin:$PATH
export PATH=/usr/local/Cellar/ruby/2.0.0-p247/bin:$PATH

export NODE_PATH=/usr/local/bin/node
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
export PATH="$NODE_PATH/bin:$PATH;"

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Link Homebrew casks in `/Applications` rather than `~/Applications`
export HOMEBREW_CASK_OPTS="--appdir=/Applications";