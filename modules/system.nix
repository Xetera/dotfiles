{
  pkgs,
  hostname,
  username,
  ...
}:
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
    hostName = hostname;
    computerName = hostname;
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
  services.yabai = import ./yabai.nix;
  services.skhd = (import ./skhd.nix { inherit pkgs; });
  services.spoofdpi = import ./spoofdpi.nix;

  system = {
    stateVersion = 5;
    primaryUser = "xetera";
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.activateSettings.text = ''
      reloadzsh
    '';

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
      smb.NetBIOSName = hostname;

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
      screencapture = {
        type = "jpg";
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
        TrackpadRightClick = true;
      };
    };
  };

  programs.fish.enable = true;
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = [ username ];
  environment.shells = [ pkgs.fish ];
}
