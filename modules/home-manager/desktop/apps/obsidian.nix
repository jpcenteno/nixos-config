{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.obsidian;
in {
  options.jpcenteno-home.desktop.apps.obsidian = {
    enable = lib.mkEnableOption "Obsidian";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ];
  };
}
