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
  elixir
  erlang
  eza
  fd
  ffmpeg
  fishPlugins.nvm
  fzf
  git
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
  nixfmt-rfc-style
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
  unison-ucm
  uv
  wezterm
  yaak
  yt-dlp
  zig
  zoxide
  # unfree
  pkgsUnfree.obsidian
]
