# server-setup-script

This will create a new user called "worker", setup the github self hosted runner, install docker, and setup the runner to run as a service.

1. Navigate to your organization and get a token for the runner.
   A. Go to your organization settings
    B. Go to "Actions"
    C. Go to "Runners"
    D. Click "Add Runner"
    E. Copy the token from the line that says `./config.sh --url https://github.com/sounding-board-labs --token <COPY THIS TOKEN>`
2. Run the following commands to setup the runner, replace the token with the one you copied in step 1.
```bash
git clone https://github.com/ericwooley/server-setup-script.git;
cd server-setup-script;
sudo GH_ACTIONS_RUNNER_TOKEN=<TOKEN>  ./setup.sh;
```
