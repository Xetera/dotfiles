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
    nixpkgs-darwin.url = "github:NixOS/nixpkgs?rev=d2faa1bbca1b1e4962ce7373c5b0879e5b12cef2";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-topology.url = "github:oddlama/nix-topology";
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
      darwin,
      home-manager,
      ...
    }:
    let
      # TODO replace with your own username, system and hostname
      username = "xetera";
      system = "aarch64-darwin"; # aarch64-darwin or x86_64-darwin
      hostname = "tim";

      specialArgs = inputs // {
        inherit username hostname;
      };
    in
    {
      darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          ./modules/nix-core.nix
          ./modules/apps.nix
          # ./modules/host-users.nixinputs.
          ./modules/system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              # useGlobalPkgs = true;
              # useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.${username} = import ./home.nix;
            };
          }
        ];
      };
      # nix code formatter
      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    };
}
