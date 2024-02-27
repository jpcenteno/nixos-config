{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # Important: Specify branch following same release as nixpkgs.
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, unstable-nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstablePkgs = import unstable-nixpkgs { system = "${system}"; config = { allowUnfree = true; }; };
    in
    {

      nixosConfigurations = {
        abend = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit unstablePkgs; };
          modules = [
            ./hosts/abend/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };

    };
}
