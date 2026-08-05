{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno-home.desktop.hyprland.wofi;
in
{
  options.jpcenteno-home.desktop.hyprland.wofi = {
    enable = lib.mkEnableOption "Wofi";
  };

  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;
    };
  };
}
