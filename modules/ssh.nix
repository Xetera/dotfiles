{
  extraConfig = ''
    Host git.xetera.dev
      IdentityFile ~/.ssh/homelab
      Port 2222

    IdentityFile ~/.ssh/hetzner
    IdentityFile ~/.ssh/kube
    IdentityFile ~/.ssh/plex
    IdentityFile ~/.ssh/id_rsa
    UseKeychain yes
  '';
}
