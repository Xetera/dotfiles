{ pkgs }:
let
  pkgsUnfree = import pkgs.path {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "obsidian"
      ];
    localSystem = pkgs.stdenv.hostPlatform;
  };
in
with pkgs;
[
  pkgsUnfree.obsidian
  ## tooling ##
  eza
  bat
  tokei
  fd
  sd
  procs
  ripgrep
  semgrep
  dua
  fzf
  delta
  docker
  hexyl
  yt-dlp
  trippy
  stripe-cli
  zoxide
  wezterm
  posting
  kubecolor
  k9s
  spotify-player
  yaak
  pay-respects
  uv
  syncthing

  devenv

  ## hacking ##
  # apkleaks

  ## productivity ##
  lazygit
  lazydocker
  btop
  jq
  jless
  postgresql
  numbat
  glances
  dive

  ## network ##
  #wireshark # -> installed in homebrew
  nmap
  tcpreplay

  ## VA ##
  ffmpeg
  # vlc unsupported?
  audacity

  ## developer setup ##
  fishPlugins.nvm
  git
  neovim
  antidote
  pnpm
  elixir
  erlang
  zig
  # zed-editor broken for now

  # misc
  nixfmt-rfc-style
  restic
]
