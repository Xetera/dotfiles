{ pkgs }:
{
  enable = true;
  preferAbbrs = true;
  generateCompletions = true;
  shellAbbrs = {
    ".." = "z ..";
    "..." = "z ../..";
    "...." = "z ../../..";
    k = "kubectl";
    ls = "eza -lb --icons";
    vim = "nvim";
    lg = "lazygit";
    editc = "nvim ~/.config/nix";
    ee = "nvim ~/.config/nix";
    update = "sudo darwin-rebuild switch --flake ~/.config/nix#tim";
    dlp = "yt-dlp --no-mtime";
    psql = "nix shell nixpkgs#postgresql --command psql";
  };
  shellInit = ''
    set -U fish_greeting
    # make sure homebrew is in path
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # so this is necessary
    export PNPM_HOME="/Users/xetera/Library/pnpm"
    export ANDROID_HOME="/Users/xetera/Library/Android/sdk"
    export PATH="$PATH:/Users/xetera/.ghcup/hls/2.9.0.1/bin"
    export PATH="$PATH:/Users/xetera/.cargo/bin"
    export PATH="$PATH:/Users/xetera/.local/bin"
    # source /Users/xetera/.ghcup/env
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    # flux
    # . <(flux completion fish)

    #hurl() {
    #  curl https://tls.lynx-toad.ts.net/api/forward -H 'x-api-key: 4jmVoWNGHGhpenWt4' "$@"
    #}
    #mongodb() {
    #  kubectl port-forward -n offload svc/mongodb 27017 27017
    #}
  '';
}
