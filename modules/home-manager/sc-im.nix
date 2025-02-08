{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.self.sc-im;
in {
  options.self.sc-im = {
    enable = lib.mkEnableOption "SC-IM, a spreadsheet program for the terminal";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.sc-im];
  };
}
