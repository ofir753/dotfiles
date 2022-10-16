#!/bin/bash

set -e # Exit if fail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

echo 'Installing Lsp Servers & Helpers'

# CMake
python3 -m pip install cmake-language-server --user

if $NO_SUDO; then
	# pylsp instead of pyright
	python3 -m pip install 'python-lsp-server[all]' --user
	exit 0
fi

# ripgrep is nessecary too but we install it in install_basic because of a bug
sudo apt install -y curl universal-ctags

# Clangd for C/CPP
sudo apt install -y clangd

# Node
sudo apt install -y npm
sudo npm cache clean -f
sudo npm install -g n
sudo n stable

# PYRIGHT
sudo npm install -g pyright

# vim-language
sudo npm install -g vim-language-server

# bashls
sudo npm install -g bash-language-server

# RLS + rust-analyzer
source $HOME/.cargo/env
rustup component add rls rust-analysis rust-src
rustup +nightly component add rust-analyzer-preview
ln -f -s $HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer $HOME/.local/bin/rust-analyzer

# Java :(
sudo apt install -y maven default-jdk

# Lua
rm -rf $HOME/.local/lua-server
mkdir $HOME/.local/lua-server
curl -s https://api.github.com/repos/sumneko/lua-language-server/releases/latest | grep "browser_download_url.*linux-x64" | cut -d : -f 2,3 | tr -d \" | wget -P $HOME/.local/lua-server/ -qi -
tar -xf $HOME/.local/lua-server/lua-language-server-*.tar.gz -C $HOME/.local/lua-server/
ln -f -s $HOME/.local/lua-server/bin/lua-language-server $HOME/.local/bin/lua-language-server

# GOLANG
sudo apt-get install -y golang
GO111MODULE=on go install golang.org/x/tools/gopls@latest

# Cocumber
sudo npm install -g @cucumber/language-server

# javascript + typescript
sudo npm install -g typescript typescript-language-server

# ltex-ls markdown
install_ltex_ls()
{
	tar -xf *
	ln -f -s $HOME/.local/lsp/ltex-ls/ltex-ls-*/bin/ltex-ls $HOME/.local/bin/ltex-ls
	rm *.tar.gz
}

download_latest_release ~/.local/lsp/ltex-ls valentjn/ltex-ls linux-x64 install_ltex_ls
