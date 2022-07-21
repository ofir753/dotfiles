#!/usr/bin/env sh

# We cant link from wsl to windows unforutently

APPDATA=$(wslpath -a "$(cmd.exe /c echo %APPDATA%)" | tr -d '\r')

echo "--------------------------"
# Copy startup files
cp -v startup/* $APPDATA/Microsoft/Windows/Start\ Menu/Programs/Startup/

# alacritty config
mkdir -p $APPDATA/alacritty
cp -v alacritty.yml $APPDATA/alacritty/
