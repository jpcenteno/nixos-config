{ inputs, ... }:
let
  name = "stylix";
in
{
  flake.modules = {
    nixos.${name} = {
      imports = [ inputs.stylix.nixosModules.stylix ];
    };

    homeManager.${name} = {
      imports = [ inputs.stylix.homeModules.stylix ];
    };
  };
}
