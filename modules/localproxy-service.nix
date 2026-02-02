{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.localproxy;
  localproxy = pkgs.callPackage ../derivations/localproxy.nix {};
in
{
  options.services.localproxy = {
    enable = mkEnableOption "localproxy - Turn random port numbers into .localhost domains";

    watch = mkOption {
      type = types.arrayOf types.str;
      description = "Folders to watch for local processes";
    };

    logLevel = mkOption {
      type = types.enum ["debug" "info" "warn" "error"];
      default = "info";
      description = "Log level";
    };

    traceProcessLogs = mkOption {
      type = types.bool;
      default = false;
      description = "Enables tracing logs from local processes. Dangerous to turn on if on macos and not using Tahoe";
    };

    httpsRedirect = mkOption {
      type = types.bool;
      default = false;
      description = "Redirects all HTTP traffic to HTTPS";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional command-line arguments to pass to localproxyd";
    };
  };

  config = mkIf cfg.enable {
    launchd.user.agents.localproxy = {
      serviceConfig = {
        ProgramArguments = [
          "${localproxy}/bin/localproxyd"
        ] ++ (concatMap (x: ["--watch" x]) cfg.watch) ++ [
          "--https-redirect"
          (toString cfg.httpsRedirect)
          "--trace-process-logs"
          (toString cfg.traceProcessLogs)
          "--log-level"
          (toString cfg.logLevel)
        ] ++ cfg.extraArgs;

        KeepAlive = true;
        RunAtLoad = true;
        StandardErrorPath = "/tmp/localproxy.err";
        StandardOutPath = "/tmp/localproxy.out";
      };
    };

    environment.systemPackages = [ localproxy ];
  };
}
