{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.hyprland;
in {

  options.jpcenteno-home.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf cfg.enable {

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "${pkgs.alacritty}/bin/alacritty";
        "$menu" = "${pkgs.wofi}/bin/wofi --show drun";

        bind = [
          "$mod, t, exec, $terminal"
          "$mod, return, exec, $terminal"
          "$mod, d, exec, $menu"
          "$mod, space, exec, $menu"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"

          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
        ];
      };
    };

  };

}
