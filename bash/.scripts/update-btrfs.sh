#!/bin/bash

sudo timeshift --create --comments "update $(date +%y)w$(date +%U)"
sudo /etc/grub.d/41_snapshots-btrfs
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo pacman -Syu
