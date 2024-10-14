{ config, lib, ... }:
let cfg = config.jpcenteno-home.shell.extras.bat;
in {

  options.jpcenteno-home.shell.extras.bat = { enable = lib.mkEnableOption "Bat"; };

  config = lib.mkIf cfg.enable {
    programs.bat.enable = true;
    xdg.configFile."bat/config".source = ../../../dotfiles/bat/config;
  };
}
