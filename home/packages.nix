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
  antidote
  audacity
  bat
  btop
  delta
  devenv
  dive
  docker
  dua
  dust
  beamPackages.elixir
  beamPackages.erlang
  eza
  fd
  ffmpeg
  fishPlugins.nvm
  fzf
  git
  go
  glances
  hexyl
  jless
  jq
  jujutsu
  k9s
  kubecolor
  lazydocker
  lazygit
  neovim
  nixfmt
  nmap
  numbat
  pay-respects
  pnpm
  postgresql
  posting
  procs
  restic
  ripgrep
  sd
  spotify-player
  stripe-cli
  syncthing
  tcpreplay
  tokei
  trippy
  typst
  uv
  wezterm
  yaak
  yt-dlp
  zig
  zoxide
  # runtimes / dev toolchains
  rustup
  # android
  android-tools
  # unfree
  pkgsUnfree.obsidian
]
