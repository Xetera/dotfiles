{
  extraConfig = ''
    IdentityFile ~/.ssh/hetzner
    IdentityFile ~/.ssh/kube
    IdentityFile ~/.ssh/plex
    IdentityFile ~/.ssh/id_rsa
    UseKeychain yes
  '';
}
