{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.desktop.apps.keepassxc;
in
{
  options.jpcenteno-home.desktop.apps.keepassxc = {
    enable = lib.mkEnableOption "KeepassXC";

    enableChromiumIntegration = lib.mkEnableOption "Chromium extension" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.keepassxc ];

    programs.chromium.extensions = lib.optional cfg.enableChromiumIntegration { id = "oboonakemofpalcgghocfoadofidjkkk"; };
  };
}
