{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    zen-browser.url = "github:jpcenteno/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter."${system}" = pkgs.alejandra;

    nixosModules = {
      default = import ./modules/nixos/default.nix;
      hello = import ./modules/nixos/hello.nix;
      keyd = import ./modules/nixos/keyd.nix;
    };

    homeManagerModules = {
      default = import ./modules/home-manager self;
      hello = import ./modules/home-manager/hello.nix;
      alacritty = import ./modules/home-manager/alacritty.nix;
      brave-browser = import ./modules/home-manager/desktop/apps/brave.nix;
      desktop.fonts = import ./modules/home-manager/desktop/fonts.nix;
      desktop.apps = import ./modules/home-manager/desktop/apps;
      git = import ./modules/home-manager/git.nix;
      hyprland = import ./modules/home-manager/desktop/hyprland.nix;
      tmux = import ./modules/home-manager/tmux.nix;
    };
  };
}
