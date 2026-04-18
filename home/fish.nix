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
    "?" = "erd -H -L 2";
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
    dlp = "yt-dlp --no-mtime --cookies-from-browser brave";
    # port forwarding from my local cluster cuz who wants to install mongodb locally
    mongodb = "kubectl port-forward -n offload svc/mongodb 27017 27017";
  };
  shellInit = ''
    set -U fish_greeting
    /opt/homebrew/bin/brew shellenv | source
    fish_vi_key_bindings
    bind ctrl-f accept-autosuggestion
    bind ctrl-j history-search-backward
    bind ctrl-k history-search-forward
    set -gx DOTNET_ROOT ~/dotnet
    set -gpx PATH ~/dotnet
    # BEGIN opam configuration
    # This is useful if you're using opam as it adds:
    #   - the correct directories to the PATH
    #   - auto-completion for the opam binary
    # This section can be safely removed at any time if needed.
    test -r '/Users/xetera/.opam/opam-init/init.fish' && source '/Users/xetera/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
    # END opam configuration
  '';
}
