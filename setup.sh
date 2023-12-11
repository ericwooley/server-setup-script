#! /usr/bin/env bash

# strict mode
set -euo pipefail

# install vim, git, and development tools
echo "Updating apt-get"
sudo apt-get update
echo "Upgrading apt-get"
sudo apt-get upgrade -y
echo "Installing vim, git, and build-essential"
sudo apt-get install -y vim git build-essential

## install node 20
echo "Installing node 20"
sudo snap install node --classic --channel=20

# install unattened upgrades
echo "Installing unattended-upgrades"
sudo apt-get install -y unattended-upgrades

# Setup unattended upgrades
echo "Setting up unattended-upgrades"
sudo dpkg-reconfigure -pmedium unattended-upgrades

# create a new user named "worker" with home directory
sudo useradd -m worker

# Create a docker group and add worker to it
sudo groupadd docker

# add current user to docker group
sudo usermod -aG docker $USER

# and add it to the docker group
sudo usermod -aG docker worker

# change "worker" to use zsh
sudo chsh -s /usr/bin/zsh worker

# change shell for current user
sudo chsh -s /usr/bin/zsh $USER

# add spaceship prompt
npm install -g spaceship-prompt

# make vim the default editor for worker, and my account
echo "Setting vim as default editor"
echo "export EDITOR=vim" >>/home/worker/.zshrc
echo "export EDITOR=vim" >>/home/$USER/.zshrc

# Add to the login message to tell user to use worker account.
sudo cat custom-message.md >/etc/update-motd.d/99-custom-welcome
