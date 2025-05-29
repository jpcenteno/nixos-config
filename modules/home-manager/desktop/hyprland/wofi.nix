{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.wofi;
in {
  options.jpcenteno-home.desktop.hyprland.wofi = {
    enable = lib.mkEnableOption "Wofi";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wofi ];
  };
}
