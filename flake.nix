{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # Important: Specify branch following same release as nixpkgs.
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = import nixpkgs-unstable {
        system = "${system}";
        config = { allowUnfree = true; };
      };
    in {
      formatter."${system}" = pkgs.nixfmt;

      nixosConfigurations = {
        abend = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./hosts/abend/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };

      nixosModules = {
        hello = import ./modules/nixos/hello.nix;
        keyd = import ./modules/nixos/keyd.nix;
      };

      homeManagerModules = {
        default = import ./modules/home-manager;
        hello = import ./modules/home-manager/hello.nix;
        alacritty = import ./modules/home-manager/alacritty.nix;
        brave-browser = import ./modules/home-manager/brave.nix;
        desktop.fonts = import ./modules/home-manager/desktop/fonts.nix;
        desktop.apps = import ./modules/home-manager/desktop/apps;
        git = import ./modules/home-manager/git.nix;
        hyprland = import ./modules/home-manager/desktop/hyprland.nix;
        tmux = import ./modules/home-manager/tmux.nix;
      };

    };
}
