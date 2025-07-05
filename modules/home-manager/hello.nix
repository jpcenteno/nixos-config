/*
    hello.nix
  *
  * This module is intended as an example taht provides a simple test * to make
  sure that the `homeManagerModules` exported by this Flake are * exported
  correctly and their options accessible to the end user.
  *
  * It installs the `hello` package at the user level.
*/
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.jpcenteno-home.hello;
in
{
  options.jpcenteno-home.hello = {
    enable = lib.mkEnableOption "Enables `hello` at a system level for testing purposes.";
  };

  config = lib.mkIf cfg.enable {
    warnings = [
      "You have enabled the home-manager module `hello.nix`. Dont forget to disable it once testing is done!"
    ];

    home.packages = [ pkgs.hello ];
  };
}
