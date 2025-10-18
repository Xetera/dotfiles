{ pkgs }:
with pkgs;
[
  ## tooling ##
  eza
  bat
  tokei
  fd
  ripgrep
  semgrep
  dust
  fzf
  delta
  docker
  hexyl
  yt-dlp
  trippy
  stripe-cli
  # binsider -> broken?

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
  wireshark # -> installed in homebrew
  nmap
  tcpreplay

  ## VA ##
  ffmpeg
  # vlc unsupported?
  audacity

  # networking
  # tailscale

  ## developer setup ##
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
