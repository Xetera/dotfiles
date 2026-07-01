{
  matchBlocks = {
    "git.xetera.dev" = {
      identityFile = "~/.ssh/homelab";
      port = 2222;
    };
    "*" = {
      identityFile = [
        "~/.ssh/hetzner"
        "~/.ssh/kube"
        "~/.ssh/plex"
        "~/.ssh/id_rsa"
      ];
      extraOptions.UseKeychain = "yes";
    };
  };
}
