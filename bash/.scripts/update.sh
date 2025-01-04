#!/bin/bash

# yyw##
week_code() {
  echo "$(date +%y)w$(date +%U)"
}

sudo timeshift --create --comments "update $(week_code)"
sudo pacman -Syu
