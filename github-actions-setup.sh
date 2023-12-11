#! /usr/bin/env bash

# strict mode
set -euo pipefail

# check that the github actions token is set $GH_ACTIONS_RUNNER_TOKEN
if [[ -z "${GH_ACTIONS_RUNNER_TOKEN}" ]]; then
  echo "GH_ACTIONS_RUNNER_TOKEN is unset, use https://github.com/organizations/<your org>/settings/actions/runners/new?arch=x64&os=linux to get the setup token out of the github instructions"
  exit 1
fi

$HOME=/home/$USER
cd /home/$USER
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
echo "29fc8cf2dab4c195bb147384e7e2c94cfd4d4022c793b346a6175435265aa278  actions-runner-linux-x64-2.311.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
./config.sh --url https://github.com/sounding-board-labs --token $GH_ACTIONS_RUNNER_TOKEN --unattended --replace
sudo ./svc.sh install worker
sudo ./svc.sh start
