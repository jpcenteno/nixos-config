/* hello.nix
 *
 * This module is intended as an example which provides a simple test
 * to make sure that the `nixosModules` exported by this Flake are
 * exported correctly and their options accessible to the end user.
 *
 * It installs the `hello` package at a system level.
 */
{ pkgs, lib, config, ... }:
let
  cfg = config.hello;
in {
  options.hello = {
    enable = lib.mkEnableOption "Enables `hello` at a system level for testing purposes.";
  };

  config = lib.mkIf cfg.enable {
    warnings = [
      "You have enabled the nixosModule `hello.nix`. Dont forget to disable it once testing is done!" 
    ];

    environment.systemPackages = [ pkgs.hello ];
  };
}
