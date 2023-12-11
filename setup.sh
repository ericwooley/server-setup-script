#! /usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
# check that the github actions token is set $GH_ACTIONS_RUNNER_TOKEN
if [[ -z "${GH_ACTIONS_RUNNER_TOKEN}" ]]; then
  echo "GH_ACTIONS_RUNNER_TOKEN is unset, use https://github.com/organizations/<your org>/settings/actions/runners/new?arch=x64&os=linux to get the setup token out of the github instructions"
  exit 1
fi
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

echo "Installing playwright dependencies"
sudo npx --yes playwright install-deps

echo "Installing nvm"
sudo cp ./shell-setup.sh /home/worker/shell-setup.sh
sudo cp ./github-actions-setup.sh /home/worker/github-actions-setup.sh
sudo chown worker:worker -R /home/worker/

sudo ./give-worker-sudo.sh
sudo -u worker /bin/bash -c "cd /home/worker && USER=worker HOME=/home/worker sudo -E ./shell-setup.sh"
sudo -E -u worker /bin/bash -c "cd /home/worker && USER=worker HOME=/home/worker ./github-actions-setup.sh"

sudo ./remove-worker-sudo.sh

echo "Installing nvm for worker"
## install nvm for current user
./shell-setup.sh

# Add to the login message to tell user to use worker account.
# sudo cat custom-message.md >/etc/update-motd.d/99-custom-welcome
