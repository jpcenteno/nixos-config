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
      base16-color-table =
        let
          name = "base16-color-table";
          src = builtins.readFile ./base16-color-table.sh;
          patchShebangs =
            package:
            package.overrideAttrs (old: {
              buildCommand = "${old.buildCommand}\n patchShebangs $out";
            });
        in
        patchShebangs (pkgs.writeScriptBin name src);
    in
    lib.mkIf cfg.enable {
      home.packages = [
        base16-color-table
      ];
    };
}
