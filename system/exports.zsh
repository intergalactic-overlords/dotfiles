export EDITOR='brackets'

# PATHS
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$PATH:~/bin
export PATH=/usr/local/Cellar/ruby/2.0.0-p247/bin:$PATH
export PATH=~/.nvm/v0.10.29/bin:$PATH

# NVM path
#export NVM_DIR="~/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

# Link Homebrew casks in `/Applications` rather than `~/Applications`
export HOMEBREW_CASK_OPTS="--appdir=/Applications";