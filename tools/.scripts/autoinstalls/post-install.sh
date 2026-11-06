#!/bin/bash
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
    openssh
    rclone
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
    jq
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
    jdk-openjdk
    github-cli
    marksman
    ruff
    prettier
    nodejs
    go
    tree-sitter-cli
    python-pynvim
    uv
    )
for package in ${dev_tools[@]}; do
    sudo pacman -S --noconfirm ${package}
done

# ===============================================================================
# DESKTOP SOFTWARE
# ===============================================================================

echo -e "[\033[33mINFO\033[0m] Installing desktop software"
desktop_soft=(
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
    youtube-music-for-desktop-bin
    wps-office-cn
    ttf-wps-fonts
    wechat-bin

    # my own packages
    suisave
    gremux
    )
for package in ${aur_packages[@]}; do
    paru -S --noconfirm ${package}
done

# also add the official way to install codex cli and codex desktop from openai for arch
# i think in this pc is an additional repo to pacman?

# final checks
# check binaries in path for kei, rpy, and reicloud-sync, if not warn to install them
