# This module is intended as a minimal test and example.
let
  warningMsg = class: "Don't forget to un-import the `hello` ${class} module.";
in
{
  flake.modules = {
    nixos.hello =
      { pkgs, ... }:
      {
        warnings = [ (warningMsg "NixoS") ];
        environment.systemPackages = [ pkgs.hello ];
      };

    homeManager.hello =
      { pkgs, ... }:
      {
        warnings = [ (warningMsg "Home-Manager") ];
        home.packages = [ pkgs.hello ];
      };
  };
}
