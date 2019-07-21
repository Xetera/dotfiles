#!/usr/bin/env bash

echo "Installing ansible..."
sudo apt install ansible

echo "Running dotfiles..."
ansible-playbook -i ~/.dotfiles/hosts ~/.dotfiles/setup.yml