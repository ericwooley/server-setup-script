#! /usr/bin/env bash

# strict mode
set -euo pipefail

# install vim, git, and development tools
sudo apt-get update
sudo apt-get install -y vim git build-essential
## install node 20
sudo snap install node --classic --channel=20

# install unattened upgrades
sudo apt-get install -y unattended-upgrades

# create a new user named "worker" with home directory
sudo useradd -m worker

# and add it to the docker group
sudo usermod -aG docker worker

# change "worker" to use zsh
sudo chsh -s /usr/bin/zsh worker

# change shell for current user
sudo chsh -s /usr/bin/zsh $USER

# add spaceship prompt
npm install -g spaceship-prompt

# make vim the default editor for worker, and my account

# Setup unattended upgrades
dpkg-reconfigure -pmedium unattended-upgrades

# Add to the login message to tell user to use worker account.
sudo cat custom-message.md >/etc/update-motd.d/99-custom-welcome
