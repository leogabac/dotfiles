#!/bin/bash

echo "(1) Install zerotier (Press ENTER to continue)"
read
sudo pacman -S zerotier-one

echo "Enabling zerotier-one.service on startup"
sudo systemctl enable zerotier-one.service
sleep 1
echo "Starting zerotier-one.service... "
sudo systemctl restart zerotier-one.service
sleep 10

echo "(2) Verify status (Press ENTER to continue)"
read
echo -e "\e[32m $(sudo zerotier-cli status)\e[0m"

read -p "(3) Enter Network ID: " nid
sudo zerotier-cli join $nid

sleep 2
sudo zerotier-cli listnetworks
