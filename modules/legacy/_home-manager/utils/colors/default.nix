{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.utils.colors;
in
{
  options.jpcenteno-home.utils.colors = {
    enable = lib.mkEnableOption "utilities for colors";
  };

  config =
    let
      patchShebangs =
        package:
        package.overrideAttrs (old: {
          buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });

      colors =
        let
          name = "colors";
          src = builtins.readFile ./colors.sh;
        in
        patchShebangs (pkgs.writeScriptBin name src);

      base16-color-table =
        let
          name = "base16-color-table";
          src = builtins.readFile ./base16-color-table.sh;
        in
        patchShebangs (pkgs.writeScriptBin name src);
    in
    lib.mkIf cfg.enable {
      home.packages = [
        colors
        base16-color-table
      ];
    };
}
