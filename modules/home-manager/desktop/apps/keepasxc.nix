{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.keepassxc;
in {
  options.jpcenteno-home.desktop.apps.keepassxc = {
    enable = lib.mkEnableOption "KeepassXC";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.keepassxc ];
  };
}
