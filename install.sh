#!/bin/bash

set -euo pipefail

mkdir -p ~/.local/bin

script_dir=$(dirname $0)

function install-executable {
  cp -f "$script_dir/$1" ~/.local/bin/$1
  chmod +x ~/.local/bin/$1
  echo "Installed $1"
}

function install-launch-agent {
  cp -f "$script_dir/$1" ~/Library/LaunchAgents/$1
  sed -i '' "s/{{username}}/$USER/g" ~/Library/LaunchAgents/$1
  launchctl unload ~/Library/LaunchAgents/$1 2> /dev/null || true
  launchctl load ~/Library/LaunchAgents/$1
  echo "Loaded $1"
}

install-executable escalate-privileges
install-executable remove-privileges-from-dock

install-launch-agent dev.silcock.drew.escalate-privileges.agent.plist
install-launch-agent dev.silcock.drew.remove-privileges-from-dock.agent.plist
