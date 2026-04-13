{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno-home.desktop.apps.ghostty;
in
{
  options.jpcenteno-home.desktop.apps.ghostty = {
    enable = lib.mkEnableOption "Ghostty";
  };

  config = lib.mkIf cfg.enable { };
}
