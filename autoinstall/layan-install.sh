#!/bin/bash
echo "Press ENTER to install kvantum"
read
sudo pacman -S kvantum

echo "Press ENTER to clone and install layan"
mkdir ~/Documents/layan-kde
git clone https://github.com/vinceliuice/Layan-kde.git ~/Documents/layan-kde
cd ~/Documents/layan-kde
./install.sh
