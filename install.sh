#!/bin/sh

# Get current dir (to run this script from anywhere)
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Update dotfiles itself first
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Bunch of symlinks
log_message "symlinking.."
# ln -sfhv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfhv "$DOTFILES_DIR/runcom/.zshrc" ~
ln -sfhv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfhv "$DOTFILES_DIR/git/.gitignore_global" ~

# install homebrew
log_message "Brewing ALL THE THINGS.."
if [[ ! $(which brew) ]]; then
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    # Link Homebrew casks in `/Applications` rather than `~/Applications`
    echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.bash_profile
else
    brew update
    brew upgrade
fi

brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# Install brew & brew-cask packages
brew bundle "$DOTFILES_DIR/packages/Brewfile"
brew bundle "$DOTFILES_DIR/packages/Caskfile"

# nvm
if [[ ! -f ~/.nvm/nvm.sh ]];then
    LATEST_STABLE_NODE=$(curl -s  http://nodejs.org/dist/latest/ | ${DOTFILES_DIR}/bin/g_or_native grep "\.pkg" | ${DOTFILES_DIR}/bin/g_or_native sed -e 's/<[^>]*>//g' | ${DOTFILES_DIR}/bin/g_or_native cut -d ' ' -f 1 | ${DOTFILES_DIR}/bin/g_or_native sed -e 's/node-v//g' | ${DOTFILES_DIR}/bin/g_or_native sed -e 's/\.pkg//g')
    log_message "Installing nvm and node v${LATEST_STABLE_NODE}"
    git clone https://github.com/creationix/nvm.git ~/.nvm
    source ~/.nvm/nvm.sh
    nvm install ${LATEST_STABLE_NODE}
    nvm use ${LATEST_STABLE_NODE}
    nvm alias default ${LATEST_STABLE_NODE}
fi

# rvm
if [[ ! -f ~/.rvm/scripts/rvm ]]; then
    log_message "Installing rvm"
    curl -sSL https://get.rvm.io | bash -s stable --ruby
    source ~/.rvm/scripts/rvm
fi

# node modules
log_message "Installing node modules.."
npm install -g $(cat ${DOTFILES_DIR}/packages/node)

# ruby gems
log_message "Installing ruby gems.."
gem install $(cat ${DOTFILES_DIR}/packages/ruby)

#custom osx settings
log_message "Setting custom OS-X Settings.."
source ${DOTFILES_DIR}/osxdefaults.sh

#log_message "Installing iTerm2 solarized colorschemes.."
#open ${DOTFILES_DIR}/deps/solarized/iterm2-colors-solarized/Solarized\ Dark.itermcolors
#open ${DOTFILES_DIR}/deps/solarized/iterm2-colors-solarized/Solarized\ Light.itermcolors

#hosts file
log_message "hosts file settings"
sudo cat ${DOTFILES_DIR}/settings/hosts >> /etc/hosts

# zsh
log_message "Setting zsh (FTW) as shell.."
ZSH=$(which zsh)
chsh -s ${ZSH}
sudo chsh -s ${ZSH}

# fonts
log_message "getting fonts"
wget http://www.levien.com/type/myfonts/Inconsolata.otf -O /Library/Fonts/Inconsolata.otf
wget https://gist.github.com/raw/1595572/Inconsolata-dz-Powerline.otf -O /Library/Fonts/Inconsolata-dz-Powerline.otf
wget https://gist.github.com/raw/1595572/Menlo-Powerline.otf -O /Library/Fonts/Menlo-Powerline.otf
wget https://gist.github.com/raw/1595572/mensch-Powerline.otf -O /Library/Fonts/mensch-Powerline.otf

# Finished!!!
log_message "Done, great success!!"