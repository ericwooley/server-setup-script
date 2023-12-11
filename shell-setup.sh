#! /usr/bin/env bash

# strict mode
set -euo pipefail

$HOME=/home/$USER
cd /home/$USER
echo "Installing nvm for worker in $HOME"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
echo "source ~/.nvm/nvm.sh" >>~/.zshrc

mkdir -p "$HOME/.zsh" &&
  git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.zsh/spaceship" || true
echo "source $HOME/.zsh/spaceship/spaceship.zsh" >>$HOME/.zshrc
source ~/.nvm/nvm.sh
nvm install 20
nvm alias default 20
nvm use default
echo 'export EDITOR=vim' >>.bashrc
echo 'export EDITOR=vim' >>.zshrc
echo 'SPACESHIP_USER_SHOW=always' >>.zshrc
