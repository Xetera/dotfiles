{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # nixpkgs-darwin.url = "github:NixOS/nixpkgs?rev=d2faa1bbca1b1e4962ce7373c5b0879e5b12cef2";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology.url = "github:oddlama/nix-topology";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      sops-nix,
      ...
    }:
    let
      # One entry per machine. `hostname` is derived from the attr name, so the
      # key here is the value you pass to `--flake .#<hostname>`.
      hosts = {
        tim = {
          username = "xetera";
          system = "aarch64-darwin";
        };
        ada = {
          username = "xetera";
          system = "aarch64-darwin";
        };
      };

      mkHost =
        hostname:
        {
          username,
          system,
        }:
        let
          specialArgs = inputs // {
            inherit username hostname;
          };
        in
        nix-darwin.lib.darwinSystem {
          inherit system specialArgs;
          modules = [
            {
              nixpkgs.overlays = [
                (final: prev: {
                  direnv = prev.direnv.overrideAttrs { doCheck = false; };
                })
              ];
            }
            ./modules/nix-core.nix
            ./modules/apps.nix
            ./modules/system.nix
            ./modules/spoofdpi-service.nix
            ./modules/localproxy-service.nix
            sops-nix.darwinModules.sops
            ./modules/amnezia.nix
            ./modules/raycast.nix
            ./modules/gpg-signing.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs username; };
                sharedModules = [
                  {
                    nixpkgs.overlays = [
                      (final: prev: {
                        direnv = prev.direnv.overrideAttrs { doCheck = false; };
                      })
                    ];
                  }
                ];
                users.${username} = import ./home/manager.nix;
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = builtins.mapAttrs mkHost hosts;
      # nix code formatter
      formatter."aarch64-darwin" = nixpkgs.legacyPackages."aarch64-darwin".alejandra;
    };
}
