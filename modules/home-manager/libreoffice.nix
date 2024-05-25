{ config, lib, pkgs, ... }:
let cfg = config.self.libreoffice;
in {
  options.self.libreoffice = { enable = lib.mkEnableOption "libreoffice"; };

  config = lib.mkIf cfg.enable {

    home.packages = [ pkgs.libreoffice ];

  };
}
