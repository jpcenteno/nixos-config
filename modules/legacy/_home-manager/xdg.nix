{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.xdg;
in
{
  options.jpcenteno-home.xdg = {
    enable = lib.mkEnableOption "XDG" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      mime.enable = true;
      mimeApps.enable = true;
    };

    home.packages = [ pkgs.xdg-utils ];
  };
}
