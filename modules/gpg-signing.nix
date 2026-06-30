{ config, pkgs, username, ... }:

let
  fpr = "82B477CACDA27E1E756273A09852FA374C75F6FD";
  secret = config.sops.secrets."pgp/signing-key.asc";
  gpg = "${pkgs.gnupg}/bin/gpg";
  home = "/Users/${username}";
  gnupgHome = "${home}/.gnupg";
  # sudo -u alone keeps root's HOME, so gpg would target /var/root/.gnupg.
  # Force HOME/GNUPGHOME to the user's so the import lands in the right keyring.
  asUser = "/usr/bin/sudo -u ${username} HOME=${home} GNUPGHOME=${gnupgHome}";
in
{
  # sops-nix decrypts the armored private key (PQ-age encrypted) to a path
  # owned by the user; the activation script then imports it into the user's
  # keyring exactly once. gpg --import is idempotent, but we gate on the key
  # already being present so we don't shell out on every rebuild.
  sops.secrets."pgp/signing-key.asc" = {
    sopsFile = ../secrets/gpg-signing-key.yaml;
    format = "yaml";
    key = "pgp/signing-key.asc";
    path = "/Users/${username}/.gnupg/sops-signing-key.asc";
    owner = username;
    mode = "0400";
  };

  system.activationScripts.importGpgSigningKey.text = ''
    if ! ${asUser} ${gpg} --list-secret-keys ${fpr} >/dev/null 2>&1; then
      echo "importing gpg signing key ${fpr} for ${username}..."
      ${asUser} ${gpg} --batch --import ${secret.path} || \
        echo "warning: gpg import failed (will retry next activation)"
    fi
  '';
}
