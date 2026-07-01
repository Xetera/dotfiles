{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.amneziawg;
  configPath = config.sops.secrets."amnezia/awg0.conf".path;
  # awg-quick calls the standard `wg` binary internally (upstream packaging quirk),
  # but amnezia configs use obfuscation keys (Jc/S1/S2) that only `awg` understands,
  # so alias wg -> awg on the runtime PATH.
  wgCompat = pkgs.runCommand "awg-wg-compat" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.amneziawg-tools}/bin/awg $out/bin/wg
  '';
  runtimePackages = [ wgCompat pkgs.amneziawg-tools pkgs.amneziawg-go pkgs.bash ];
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

    launchd.daemons.amneziawg = {
      serviceConfig = {
        ProgramArguments = [
          "${pkgs.amneziawg-tools}/bin/awg-quick"
          "up"
          configPath
        ];
        RunAtLoad = true;
        KeepAlive = false;
        StandardErrorPath = "/var/log/amneziawg.err";
        StandardOutPath = "/var/log/amneziawg.out";
        EnvironmentVariables = {
          PATH = "${makeBinPath runtimePackages}:/usr/bin:/bin:/usr/sbin:/sbin";
        };
      };
    };
  };
}
