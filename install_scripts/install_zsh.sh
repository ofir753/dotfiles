#!/bin/bash

sudo apt install -y zsh

# Change default shell
if [ ! $0 = "-zsh" ]; then
  echo 'Changing default shell to zsh'
  sudo chsh -s /bin/zsh
else
  echo 'Already using zsh'
fi

# Check if oh-my-zsh is installed
OMZDIR="$HOME/.oh-my-zsh"
if [ ! -d "$OMZDIR" ]; then
  echo 'Installing oh-my-zsh'
  /bin/sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Install zsh plugins
mkdir -p ~/.oh-my-zsh/custom/plugins

install_plugin() {
  if [ ! -d "$2" ] ; then
    git clone "$1" "$2"
  fi
}
install_plugin https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
install_plugin https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
install_plugin https://github.com/paulirish/git-open.git ~/.oh-my-zsh/custom/plugins/git-open

