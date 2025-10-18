{ pkgs, ... }:
###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{
  networking = {
    dns = [
      "100.100.100.100"
      "10.0.0.1"
      # in case something goes wrong with dns
      "1.1.1.1"
    ];
    knownNetworkServices = [
      "Wi-Fi"
      "Bluetooth PAN"
      "Thunderbolt Bridge"
      "NextDNS"
      "Tailscale Tunnel"
    ];
  };
  environment.shellAliases = {
  };

  services.yabai = import ./yabai.nix;
  system = {
    stateVersion = 5;
    primaryUser = "xetera";
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.activateSettings.text = ''
      reloadzsh
    '';

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock

      # other macOS's defaults configuration.
      # ......

      dock = {
        autohide = true;
        mru-spaces = false;
        tilesize = 1024;
      };

      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
        TrackpadRightClick = true;
      };
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  # programs.zsh.enable = true;
  programs.zsh.enable = true;
  users.users.xetera = {
    home = "/Users/xetera";
    shell = pkgs.zsh;
  };
  # this doesn't actually set the shell to the right thing.
  # Need to run these commands to make it work? I hate nix-darwin
  # echo "$(which zsh)" | sudo tee -a /etc/shells
  # chsh -s $(which zsh) $USER
  environment.shells = [ pkgs.zsh ];
}
