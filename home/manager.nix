{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  gitName = "Xetera";
  gitEmail = "contact@xetera.dev";
in
{
  home = {
    # weird errors causd by this one
    enableNixpkgsReleaseCheck = false;
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
      "claude-code"
      "kiro"
    ];
  imports = [ inputs._1password-shell-plugins.hmModules.default ];

  services.syncthing = import ./syncthing.nix;
  programs = {
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    pay-respects = import ./pay-respects.nix;
    starship = (import ./starship.nix { inherit pkgs lib; });
    bash.initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
    fish = (import ./fish.nix { inherit pkgs; });
    zoxide = import ./zoxide.nix;
    lazygit = (
      import ./lazygit.nix {
        inherit lib;
        inherit pkgs;
        inherit gitName;
      }
    );
    opencode = import ./opencode.nix;
    wezterm = import ./wezterm.nix;
    alacritty = import ./alacritty.nix;
    git = (
      import ./git.nix {
        inherit pkgs;
        inherit gitName;
        inherit gitEmail;
      }
    );
    jujutsu = import ./jujutsu.nix {
      inherit gitName;
      inherit gitEmail;
    };
    claude-code = import ./claude.nix;
    _1password-shell-plugins = {
      enable = true;
      plugins = with pkgs; [ gh ];
    };
  };
}
