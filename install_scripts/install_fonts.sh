#!/bin/bash

set -e # Exit if fail

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

download_font()
{
	font=$1

	rm -f $font.zip
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/$font.zip
	unzip -o $font.zip
	# dont remove .zip
}

download_font CascadiaCode
download_font UbuntuMono
download_font JetBrainsMono

# Remove custom italic fonts
rm -f *Italic*

fc-cache -f -v
