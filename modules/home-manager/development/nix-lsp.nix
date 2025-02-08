# This module optionally installs extra Nix development tools.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.development.nil;
in {
  options.development.nil = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Wether to install extra Nix development tools.
      '';
    };
  };

  config = lib.mkIf cfg.enable {home.packages = with pkgs; [nil nixfmt];};
}
