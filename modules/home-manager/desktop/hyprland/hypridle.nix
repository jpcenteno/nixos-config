{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.hypridle;
in {
  options.jpcenteno-home.desktop.hyprland.hypridle = {
    enable = lib.mkEnableOption "Hypridle";
  };

  config = lib.mkIf cfg.enable {
    # FIXME Add an assertion or warning when Hyprland is disabled.

    # NOTE This requires `wayland.windowManager.hyprland.enabe = true`.
    wayland.windowManager.hyprland.settings.exec-once = [
      "${config.services.hypridle.package}/bin/hypridle"
    ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          # lock_cmd = "";
        };

        listener = let
          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        in [
          {
            timeout = "60"; # 1 minute.
            on-timeout = "${brightnessctl} --save set 10";
            on-resume = "${brightnessctl} --restore";
          }
        ];
      };
    };
  };
}
