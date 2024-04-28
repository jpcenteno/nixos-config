{ config, lib, pkgs, ... }:
let cfg = config.self.shell-enhancements.eza;
in {

  options.self.shell-enhancements.eza = { enable = lib.mkEnableOption "Eza"; };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.eza ];

    programs.bash.shellAliases.ls = "eza";
  };
}
