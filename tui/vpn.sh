#!/bin/bash

# ===============================
# A simple vpn selectio tui
# ===============================

# NOTE: This depends on gum https://github.com/charmbracelet/gum

SELECTION=$(gum choose --header "Select VPN" "nordvpn" "zerotier")

case "$SELECTION" in
  "nordvpn")
    sudo systemctl stop zerotier-one
    sudo systemctl start nordvpnd.service
    nordvpn connect
    # to be able to access even if zerotier goes down
    # nordvpn set meshnet on
  ;;
  "zerotier")
    nordvpnd disconnect
    sudo systemctl stop nordvpnd.service
    sudo systemctl restart zerotier-one
  ;;
esac


