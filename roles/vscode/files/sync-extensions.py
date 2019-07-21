#!/usr/bin/python3
from os import system
from sys import argv
from subprocess import check_output

SAVE_FILE = "extensions.txt"

def noop():
  ...

def filter_not_blank(items):
  return [output for output in items if output != ""]

def run(cmd):
  return check_output([cmd], shell=True)

def save_extensions():
  print("Saving extensions...")
  exts = run("code --list-extensions")
  with open(SAVE_FILE, "wb") as file:
    file.write(exts)
    print("Saved extensions!")

def install_extensions():
  print("Installing extensions...")
  with open(SAVE_FILE, "r") as file:
    extensions = filter_not_blank(file.read().split("\n"))
    commands = " ".join([f"--install-extension {ext}" for ext in extensions])
    run(f"code {commands}")
    print("Installed extensions!")

actions = {
  "install": install_extensions,
  "save": save_extensions
}

if __name__=="__main__":
  if len(argv) < 2:
    print("An action must be entered")
    quit(1)
  [_, command] = argv
  actions.get(command, noop)()
