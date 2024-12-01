{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.common.cursor;
in {
  options.jpcenteno-home.desktop.common.cursor = {
    enable = lib.mkEnableOption "Cursor theme and size customization";
  };

  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS-BigSur";
      size = 32;
    };
  };
}
