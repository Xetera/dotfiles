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
  functions = {
    dotnet = {
      body = ''
        if test "$argv[1]" = "install"
          command dotnet restore $argv[2..]
        else
          command dotnet $argv
        end
      '';
    };
  };
  shellAbbrs = {
    ".." = "z ..";
    "..." = "z ../..";
    "...." = "z ../../..";
    k = "kubectl";
    ls = "eza -lab --icons";
    vim = "nvim";
    lg = "lazygit";
    editc = "nvim /etc/nix-darwin";
    ee = "nvim /etc/nix-darwin";
    update = "sudo darwin-rebuild switch --flake /etc/nix-darwin#(scutil --get LocalHostName)";
    awg = "sudo awg";
    awgup = "sudo awg-quick up /etc/amneziawg/awg0.conf";
    awgdown = "sudo awg-quick down /etc/amneziawg/awg0.conf";
    awgrestart = "sudo awg-quick down /etc/amneziawg/awg0.conf; and sudo awg-quick up /etc/amneziawg/awg0.conf";
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
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
    fish_add_path $HOME/.local/bin
    set -x DOTNET_ROOT /usr/local/share/dotnet
    set -gx JAVA_HOME ${pkgs.jdk.home}
    # BEGIN opam configuration
    # This is useful if you're using opam as it adds:
    #   - the correct directories to the PATH
    #   - auto-completion for the opam binary
    # This section can be safely removed at any time if needed.
    test -r '/Users/xetera/.opam/opam-init/init.fish' && source '/Users/xetera/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
    # END opam configuration
  '';
}
