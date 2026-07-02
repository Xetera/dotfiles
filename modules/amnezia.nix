{ config, lib, pkgs, username, ... }:

with lib;

let
  cfg = config.services.amneziawg;
  configPath = config.sops.secrets."amnezia/awg0.conf".path;

  # Upstream awg-quick applied the WireGuard->AmneziaWG rename inconsistently:
  # the name file and UAPI socket are created under /var/run/amneziawg, but
  # get_real_interface's timing guard stats /var/run/wireguard/$INTERFACE.name
  # (and teardown rm's from there too). The missing file makes stat fall back to
  # a dummy mtime, so the socket-vs-name mtime diff is always huge, the guard
  # trips, and the interface is torn down right after `amneziawg-go utun` — no
  # setconf, no address, no routes. Normalize the stray paths to /var/run/amneziawg.
  amneziawg-tools = pkgs.amneziawg-tools.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      sed -i 's#/var/run/wireguard#/var/run/amneziawg#g' $out/bin/.awg-quick-wrapped
    '';
  });

  # awg-quick calls the standard `wg` binary internally (upstream packaging quirk),
  # but amnezia configs use obfuscation keys (Jc/S1/S2) that only `awg` understands,
  # so alias wg -> awg on the runtime PATH.
  wgCompat = pkgs.runCommand "awg-wg-compat" { } ''
    mkdir -p $out/bin
    ln -s ${amneziawg-tools}/bin/awg $out/bin/wg
  '';
  runtimePackages = [ wgCompat amneziawg-tools pkgs.amneziawg-go pkgs.bash ];
in
{
  options.services.amneziawg = {
    enable = mkEnableOption "AmneziaWG VPN tunnel via awg-quick";

    interface = mkOption {
      type = types.str;
      default = "awg0";
      description = "Interface name; must match the [Interface] in the decrypted config.";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."amnezia/awg0.conf" = {
      sopsFile = ../secrets/amnezia.yaml;
      path = "/etc/amneziawg/${cfg.interface}.conf";
      mode = "0600";
    };

    environment.systemPackages = runtimePackages;

    # Let the user run awg / awg-quick via sudo without a password prompt.
    security.sudo.extraConfig = ''
      ${username} ALL=(root) NOPASSWD: ${amneziawg-tools}/bin/awg, ${amneziawg-tools}/bin/awg-quick
    '';

    launchd.daemons.amneziawg = {
      serviceConfig = {
        ProgramArguments = [
          "${amneziawg-tools}/bin/awg-quick"
          "up"
          configPath
        ];
        RunAtLoad = true;
        KeepAlive = false;
        # awg-quick backgrounds `amneziawg-go`, which double-forks and binds its
        # UAPI socket after the parent exits. Without this, launchd reaps the
        # whole process group when `awg-quick up` returns, killing the daemon
        # before it creates /var/run/amneziawg/<utun>.sock, so get_real_interface
        # fails and the tunnel is torn down. See launchd.plist(5) AbandonProcessGroup.
        AbandonProcessGroup = true;
        StandardErrorPath = "/var/log/amneziawg.err";
        StandardOutPath = "/var/log/amneziawg.out";
        EnvironmentVariables = {
          PATH = "${makeBinPath runtimePackages}:/usr/bin:/bin:/usr/sbin:/sbin";
        };
      };
    };
  };
}
