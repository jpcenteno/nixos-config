/*
  This module defines a mergeable `perSystem.devShell` option tree that allows
  multiple flake-parts modules to contribute configuration to the default
  devShell for this flake.
*/
{ lib, flake-parts-lib, ... }:
{
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    { config, pkgs, ... }:
    {
      options.devShell = lib.mkOption {
        description = ''
          Default development shell options for this flake.

          The options under this hierarchy allow me to modularize the settings
          of the default `devShell` of this flake.
        '';

        type = lib.types.submodule {
          options = {
            packages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Packages for this flake's default dev shell.";
            };

            shellHook = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "shellHook fragments for this flake's default dev shell.";
            };
          };
        };
      };
    }
  );

  config.perSystem =
    { pkgs, config, ... }:
    {
      config.devShells.default = pkgs.mkShell {
        inherit (config.devShell) packages shellHook;
      };
    };
}
