#!/bin/bash

# ===============================================================================
# SYSTEM SERVICES
# ===============================================================================

echo -e "[\033[33mINFO\033[0m] Enabling bluetooth daemon"
sudo systemctl enable --now bluetooth.service

# ===============================================================================
# BASIC SYSTEM PACKAGES
# ===============================================================================

relevant_packages=(
    git
    pacman-contrib
    fastfetch
    less
    bluez
    bluez-utils
    bluez-obex
    bluez-deprecated-tools
    dosfstools
    ntfsprogs
    rsync
    sshfs
    ripgrep
    imagemagick
    wl-clipboard
    )
for package in ${relevant_packages[@]}; do
    sudo pacman -S --noconfirm ${package}
done

# ===============================================================================
# PYTHON BUILD DEPS
# ===============================================================================

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

# ===============================================================================
# CLI
# ===============================================================================

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
    stow
    keyd
    timeshift
    cronie
    pdftk
    )
for package in ${cli[@]}; do
    sudo pacman -S --noconfirm ${package}
done

# ===============================================================================
# DEV TOOLS
# ===============================================================================

echo -e "[\033[33mINFO\033[0m] Installing dev tools"
dev_tools=(
    neovim
    pyenv
    python-virtualenv
    jdk-openjdk
    github-cli
    marksman
    ruff
    prettier
    nodejs
    tree-sitter-cli
    python-pynvim
    )
for package in ${dev_tools[@]}; do
    sudo pacman -S --noconfirm ${package}
done

# ===============================================================================
# DESKTOP SOFTWARE
# ===============================================================================

echo -e "[\033[33mINFO\033[0m] Installing desktop software"
desktop_soft=(
    firefox
    inkscape
    obs-studio
    noto-fonts-cjk
    kcolorchooser
    filelight
    flatpak
    gnome-disk-utility
    okular
    gwenview
    haruna
    )
for package in ${desktop_soft[@]}; do
    sudo pacman -S --noconfirm ${package}
done

# ===============================================================================
# LATEX
# ===============================================================================

echo -e "[\033[33mINFO\033[0m] Installing LaTeX dependencies"
sudo pacman -S texlive zathura zathura-pdf-mupdf

# ===============================================================================
# AUR PACKAGES
# ===============================================================================

echo -e "[\033[33mINFO\033[0m] Installing AUR packages"
aur_packages=(
    ttf-blex-nerd-font-git
    zotero-bin
    onlyoffice-bin
    ttf-wps-fonts
    youtube-music
    elecwhat-bin
    wechat-bin
    )
for package in ${aur_packages[@]}; do
    paru -S --noconfirm ${package}
done


