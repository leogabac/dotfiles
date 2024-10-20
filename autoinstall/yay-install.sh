#!/bin/bash

sudo pacman -S --needed base-devel git
mkdir /tmp/yay
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
