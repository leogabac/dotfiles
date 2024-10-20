#!/bin/bash
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.zip
cd ~/.local/share/fonts
unzip 0xProto.zip
rm 0xProto.zip
fc-cache -fv
