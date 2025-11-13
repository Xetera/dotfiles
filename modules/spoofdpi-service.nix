{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spoofdpi;
  spoofdpi = pkgs.callPackage ../derivations/spoofdpi.nix {};
in
{
  options.services.spoofdpi = {
    enable = mkEnableOption "SpoofDPI - A simple DPI bypass proxy";

    listenAddr = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "IP address to bind to";
    };

    listenPort = mkOption {
      type = types.port;
      default = 10024;
      description = "Port to listen on";
    };

    dnsAddr = mkOption {
      type = types.str;
      default = "1.1.1.1";
      description = "DNS server address";
    };

    dnsPort = mkOption {
      type = types.port;
      default = 53;
      description = "DNS server port";
    };

    windowSize = mkOption {
      type = types.ints.between 0 255;
      default = 0;
      description = "Chunk size in bytes for fragmented client hello";
    };

    fakeHttpsPackets = mkOption {
      type = types.ints.between 0 255;
      default = 0;
      description = "Number of fake packets to send before client hello";
    };

    timeout = mkOption {
      type = types.int;
      default = 2000;
      description = "Connection timeout";
    };

    logLevel = mkOption {
      type = types.enum [ "debug" "info" "warn" "error" ];
      default = "info";
      description = "Logging verbosity level";
    };

    enableDoh = mkOption {
      type = types.bool;
      default = true;
      description = "Enable DNS-over-HTTPS";
    };

    dnsIpv4Only = mkOption {
      type = types.bool;
      default = false;
      description = "Use IPv4 DNS resolution only";
    };

    allowPatterns = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of regex patterns for domains to apply DPI circumvention";
      example = [ ".*\\.example\\.com" ".*\\.blocked\\.net" ];
    };

    ignorePatterns = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of regex patterns for domains to ignore DPI circumvention";
      example = [ ".*\\.local" ];
    };

    cacheShards = mkOption {
      type = types.ints.between 1 255;
      default = 32;
      description = "Number of cache shards for performance tuning";
    };

    silent = mkOption {
      type = types.bool;
      default = false;
      description = "Suppress startup banner";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional command-line arguments to pass to SpoofDPI";
      example = [ "--system-proxy" ];
    };
  };

  config = mkIf cfg.enable {
    launchd.user.agents.spoofdpi = {
      serviceConfig = {
        ProgramArguments = [
          "${spoofdpi}/bin/spoofdpi"
          "--listen-addr" cfg.listenAddr
          "--listen-port" (toString cfg.listenPort)
          "--dns-addr" cfg.dnsAddr
          "--dns-port" (toString cfg.dnsPort)
          "--window-size" (toString cfg.windowSize)
          "--fake-https-packets" (toString cfg.fakeHttpsPackets)
          "--timeout" (toString cfg.timeout)
          "--log-level" cfg.logLevel
          "--cache-shards" (toString cfg.cacheShards)
        ] ++ (optionals cfg.enableDoh [ "--enable-doh" ])
          ++ (optionals cfg.dnsIpv4Only [ "--dns-ipv4-only" ])
          ++ (optionals cfg.silent [ "--silent" ])
          ++ (flatten (map (pattern: [ "--allow" pattern ]) cfg.allowPatterns))
          ++ (flatten (map (pattern: [ "--ignore" pattern ]) cfg.ignorePatterns))
          ++ cfg.extraArgs;

        KeepAlive = true;
        RunAtLoad = true;
        StandardErrorPath = "/tmp/spoofdpi.err";
        StandardOutPath = "/tmp/spoofdpi.out";
      };
    };

    # Add the package to system packages so it's available in PATH
    environment.systemPackages = [ spoofdpi ];
  };
}
