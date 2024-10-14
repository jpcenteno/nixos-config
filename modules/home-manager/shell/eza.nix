{ config, lib, pkgs, ... }:
let cfg = config.jpcenteno-home.shell.extras.eza;
in {

  options.jpcenteno-home.shell.extras.eza = { enable = lib.mkEnableOption "Eza"; };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.eza ];

    programs.bash.shellAliases.ls = "eza";
  };
}
