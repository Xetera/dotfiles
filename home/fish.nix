{ pkgs }:
{
  enable = true;
  preferAbbrs = true;
  generateCompletions = true;
  shellAliases = {
    kubectl = "kubecolor";
    psql = "nix shell nixpkgs#postgresql --command psql";
    psql17 = "nix shell nixpkgs#postgresql_17 --command psql";
    try = "nix run nixpkgs.";
  };
  shellAbbrs = {
    ".." = "z ..";
    "..." = "z ../..";
    "...." = "z ../../..";
    k = "kubectl";
    ls = "eza -lab --icons";
    vim = "nvim";
    lg = "lazygit";
    editc = "nvim ~/.config/nix";
    ee = "nvim ~/.config/nix";
    update = "sudo darwin-rebuild switch --flake ~/.config/nix#tim";
    dlp = "yt-dlp --no-mtime";
    # port forwarding from my local cluster cuz who wants to install mongodb locally
    mongodb = "kubectl port-forward -n offload svc/mongodb 27017 27017";
  };
  shellInit = ''
    set -U fish_greeting
    /opt/homebrew/bin/brew shellenv | source
  '';
}
