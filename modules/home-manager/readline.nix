{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.readline;
in {
  options.jpcenteno-home.readline = {
    enable = lib.mkEnableOption "Enable personal readline config";
  };

  config = lib.mkIf cfg.enable {
    programs.readline = {
      enable = true;
      extraConfig = builtins.readFile ../../dotfiles/readline/inputrc;
    };
  };
}
