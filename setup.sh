#! /usr/bin/env bash

# strict mode
set -euo pipefail

# install vim, git, and development tools
echo "Updating apt-get"
sudo apt-get update
echo "Upgrading apt-get"
sudo apt-get upgrade -y
echo "Installing vim, git, and build-essential"
sudo apt-get install -y vim git build-essential zsh

# install unattened upgrades
echo "Installing unattended-upgrades"
sudo apt-get install -y unattended-upgrades

# Setup unattended upgrades
echo "Setting up unattended-upgrades"
sudo dpkg-reconfigure -pmedium unattended-upgrades

# create a new user named "worker" with home directory
sudo useradd -m worker || echo "Failed to add 'worker' user, user probably already exists" # probably already exists

# Create a docker group and add worker to it
sudo groupadd docker || echo "Failed to add docker group, group probably already exists" # probably already exists

# add current user to docker group
sudo usermod -aG docker $USER

# and add it to the docker group
sudo usermod -aG docker worker

# change "worker" to use zsh
sudo -u worker touch /home/worker/.zshrc
sudo chsh -s /usr/bin/zsh worker

# change shell for current user
touch ~/.zshrc
sudo chsh -s /usr/bin/zsh $USER

## install node 20
# if node is not installed or the node version does not equal 20, skip this
if ! command -v node >/dev/null || [[ $(node --version) != *"v20"* ]]; then
  echo "Installing node 20"
  sudo snap install node --classic --channel=20
fi

## install nvm for worker

echo "Installing nvm for worker"
sudo su - worker /bin/bash -c "<<EOF
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
echo "source ~/.nvm/nvm.sh" >>~/.zshrc
source ~/.zshrc
nvm install 20
nvm alias default 20
nvm use default
EOF"

echo "Installing nvm for worker"
## install nvm for current user
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
echo "source ~/.nvm/nvm.sh" >>~/.zshrc
source ~/.zshrc
nvm install 20
nvm alias default 20
nvm use default

# add spaceship prompt
echo "Installing spaceship prompt"
npm install -g spaceship-prompt

# add spaceship prompt for worker
sudo -u worker npm install -g spaceship-prompt

# make vim the default editor for worker, and my account
echo "Setting vim as default editor"
echo "export EDITOR=vim" >>/home/worker/.zshrc
echo "export EDITOR=vim" >>/home/$USER/.zshrc

# Add to the login message to tell user to use worker account.
sudo cat custom-message.md >/etc/update-motd.d/99-custom-welcome
