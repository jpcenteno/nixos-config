{
  flake = {
    nixosModules = {
      default = import ./_nixos/default.nix;
    };

    homeManagerModules = {
      default = import ./_home-manager/default.nix;
    };
  };
}
