{ pkgs, ... }:
{
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  #  TODO: Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    # needed by zed
    nixd
    alejandra
    nil
  ];

  # launchd.user.agents = {
  #   syncthing = {
  #     serviceConfig = {
  #       ProgramArguments = [
  #         "${pkgs.syncthing}/bin/syncthing"
  #         "-no-browser"
  #         "-no-restart"
  #         "-home=/Users/xetera/.config/syncthing"
  #       ];
  #       KeepAlive = true;
  #       RunAtLoad = true;
  #       ProcessType = "Background";
  #       StandardOutPath = "/Users/xetera/.local/share/syncthing/stdout.log";
  #       StandardErrorPath = "/Users/xetera/.local/share/syncthing/stderr.log";
  #     };
  #   };
  # };

  programs.fish.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # services.tailscale.enable = true;

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
    };

    taps = [
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "mas"
      "nebula"
      "syncthing"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "libreoffice"
      "wireshark"
      "raycast"
      "zed@preview"
      "background-music"
      "font-monaspace"
      "font-sf-mono-nerd-font"
      "claude-code"
    ];
  };
}
