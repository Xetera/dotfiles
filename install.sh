#!/usr/bin/env bash

echo "[.files] Installing ansible..."
sudo apt install ansible

echo "[.files] Installing ansible dependencies"
ansible-galaxy install -r requirements.yml

if [ -s "vault-pass" ]; then
  echo "[.files] Password file found, using vault pass..."
  ansible-playbook -i hosts setup.yml --vault-password-file vault-pass
else
  echo "[.files] Password file NOT found, not using encryption"
  ansible-playbook -i hosts setup.yml
fi
