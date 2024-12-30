#!/bin/bash
echo "Press ENTER to install kvantum"
read
sudo pacman -S kvantum

echo "Press ENTER to clone and install layan-theme and tela-icon-theme"
mkdir ~/Documents/layan-kde
mkdir ~/Documents/telan-icon-theme

git clone https://github.com/vinceliuice/Layan-kde.git ~/Documents/layan-kde
cd ~/Documents/layan-kde
./install.sh

git clone https://github.com/vinceliuice/Tela-icon-theme.git ~/Documents/tela-icon-theme/
cd ~/Documents/tela-icon-theme/
./install.sh
