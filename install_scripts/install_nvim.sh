#!/bin/bash

set -e # Exit if fail

sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# numToStr/lemmy-help
cargo install lemmy-help --features=cli

if -d ~/.local/share/nvim; then
	echo "Skipping nvim install"
else
	~/dotfiles_scripts/misc/upgrade_nvim.sh stable
fi
