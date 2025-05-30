#!/bin/bash

echo -e "[\033[33mINFO\033[0m] Enabling bluetooth daemon"
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

relevant_packages=(
    git
    pacman-contrib
    fastfetch
    less
    bluez
    bluez-utils
    bluez-deprecated-tools
    pulseaudio-bluetooth
    dosfstools
    ntfsprogs
    rsync
    sshfs
    ripgrep
    )
for package in ${relevant_packages[@]}; do
    sudo pacman -S --noconfirm ${package}
done


echo -e "[\033[33mINFO\033[0m] Installing python build dependencies"
python_build=(
    base-devel
    openssl
    zlib
    xz
    tk
    )
for package in ${python_build[@]}; do
    sudo pacman -S --needed --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing command line utilities"
cli=(
    btop
    nvtop
    lsd
    tmux
    yazi
    kitty
    zoxide
    starship
    fzf
    timeshift
    cronie
    )
for package in ${cli[@]}; do
    sudo pacman -S --noconfirm ${package}
done


echo -e "[\033[33mINFO\033[0m] Installing dev tools"
dev_tools=(
    pyenv
    python-virtualenv
    jdk-openjdk
    github-cli
    marksman
    )
for package in ${dev_tools[@]}; do
    sudo pacman -S --noconfirm ${package}
done


echo -e "[\033[33mINFO\033[0m] Installing desktop software"
desktop_soft=(
    inkscape
    obs-studio
    signal-desktop
    noto-fonts-cjk
    kcolorchooser
    spectacle
    filelight
    flatpak
    gnome-disk-utility
    evince
    )
for package in ${desktop_soft[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing LaTeX dependencies"
sudo pacman -S texlive zathura zathura-pdf-mupdf

echo -e "[\033[33mINFO\033[0m] Installing yay"
mkdir /tmp/yay
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si

# install proto nerdfont
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.zip
cd ~/.local/share/fonts
unzip 0xProto.zip
rm 0xProto.zip
fc-cache -fv

# zerotier
sudo pacman -S zerotier-one
sudo systemctl enable zerotier-one.service
sudo systemctl start zerotier-one.service

# some aur packages
echo -e "[\033[33mINFO\033[0m] Installing AUR packages"
aur_packages=(
    brave-bin
    zotero-bin
    wps-office
    ttf-wps-fonts
    )
for package in ${aur_packages[@]}; do
    yay -S --noconfirm ${package}
done


