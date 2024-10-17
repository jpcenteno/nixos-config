{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.hyprland;
in {

  imports = [
    ./waybar.nix
  ];

  options.jpcenteno-home.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf cfg.enable {

    jpcenteno-home.waybar.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "${pkgs.alacritty}/bin/alacritty";
        "$menu" = "${pkgs.wofi}/bin/wofi --show drun";

        exec-once = [
          "${config.jpcenteno-home.waybar.package}/bin/waybar &"
        ];

        bind = [
          "$mod, t, exec, $terminal"
          "$mod, return, exec, $terminal"
          "$mod, d, exec, $menu"
          "$mod, space, exec, $menu"

          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod&SHIFT, h, movewindow, l"
          "$mod&SHIFT, j, movewindow, d"
          "$mod&SHIFT, k, movewindow, u"
          "$mod&SHIFT, l, movewindow, r"
          "$mod&SHIFT, left, movewindow, l"
          "$mod&SHIFT, right, movewindow, r"
          "$mod&SHIFT, up, movewindow, u"
          "$mod&SHIFT, down, movewindow, d"

          "$mod, TAB, cyclenext,"
          "$mod&SHIFT, TAB, cyclenext, prev"

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

          "$mod SHIFT CONTROL, q, killactive,"

        ];

        # Modifiers used:
        # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
        # e -> repeat, will repeat when held.
        bindle = let
          wpctl = "${pkgs.wireplumber}/bin/wpctl";
          setVolumeCmd = volume: "${wpctl} set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ ${volume}";

          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
          setBrightnessCmd = brightness: "${brightnessctl} set ${brightness}";
        in [
          # Volume control:
          ", XF86AudioRaiseVolume, exec, ${setVolumeCmd "5%+"}"
          ", XF86AudioLowerVolume, exec, ${setVolumeCmd "5%-"}"
          "SHIFT, XF86AudioLowerVolume, exec, ${setVolumeCmd "0"}"
          ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # Brightness control:
          ", XF86MonBrightnessUp, exec, ${setBrightnessCmd "+5%"}"
          ", XF86MonBrightnessDown, exec, ${setBrightnessCmd "5%-"}"
        ];
      };
    };

  };

}
