#!/usr/bin/env bash

echo "Installing ansible..."
sudo apt install ansible

echo "Installing ansible dependencies"
ansible-galaxy install -r requirements.yml

ansible-playbook -i ~/.dotfiles/hosts ~/.dotfiles/setup.yml