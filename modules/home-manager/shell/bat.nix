{ config, lib, pkgs, ... }:
let cfg = config.jpcenteno-home.shell.extras.bat;
in {

  options.jpcenteno-home.shell.extras.bat = { enable = lib.mkEnableOption "Bat"; };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.bat ];
    xdg.configFile."bat/config".source = ../../../dotfiles/bat/config;
  };
}
