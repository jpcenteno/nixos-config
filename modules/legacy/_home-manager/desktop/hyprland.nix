{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno-home.hyprland;
in
{
  imports = [
    ./apps/default.nix
  ];

  options.jpcenteno-home.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
    };
  };
}
