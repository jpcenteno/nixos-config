{ config, lib, pkgs, ... }:
let cfg = config.jpcenteno.home-manager.desktop.applications.virtualbox;
in {
  options.jpcenteno.home-manager.desktop.applications.virtualbox = {
    enable = lib.mkEnableOption "virtualbox";
  };

  config = lib.mkIf cfg.enable { home.packages = [ pkgs.virtualbox ]; };
}
