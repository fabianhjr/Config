{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/staging-next";
    nixpkgs.url = "flake:localnixpkgs";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, lix-module, ... }@attrs: {
    nixosConfigurations.fabian-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        lix-module.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
