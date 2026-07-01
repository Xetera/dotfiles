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
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    nonUS.remapTilde = true;
  };

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
  services.localproxy = import ./localproxy.nix;

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

  users.knownUsers = [ username ];
  users.users.${username} = {
    uid = 501;
    gid = 20;
    home = "/Users/${username}";
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = [ username ];
  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];
  environment.shells = [ pkgs.fish ];

  sops.age.keyFile = "/Users/${username}/.config/sops/age/keys.txt";
  services.amneziawg.enable = true;
}
