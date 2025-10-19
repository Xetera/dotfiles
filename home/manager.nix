{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  gitName = "Xetera";
in
{
  home = {
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = (import ./packages.nix { inherit pkgs; });
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];
  imports = [ inputs._1password-shell-plugins.hmModules.default ];

  programs = {
    fish = import ./fish.nix;
    lazygit = (
      import ./lazygit.nix {
        inherit lib;
        inherit pkgs;
        inherit gitName;
      }
    );
    wezterm = import ./wezterm.nix;
    alacritty = import ./alacritty.nix;
    git = (
      import ./git.nix {
        inherit pkgs;
        inherit gitName;
      }
    );
    _1password-shell-plugins = {
      enable = true;
      plugins = with pkgs; [ gh ];
    };
  };
}
