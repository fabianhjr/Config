{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    # nixpkgs.url = "github:NixOS/nixpkgs/staging-next";
    nixpkgs.url = "git+file:///home/fabian/Development/Open/nixpkgs/main";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/fd186f535a4ac7ae35d98c1dd5d79f0a81b7976d.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, /* lix-module, */ ... }@attrs: {
    nixosConfigurations.fabian-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.fabian = import ./home/fabian.nix;
        }

        # lix-module.nixosModules.default
      ];
    };
  };
}
