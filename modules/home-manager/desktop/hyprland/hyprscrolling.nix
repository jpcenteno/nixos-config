{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.hyprscrolling;
in {
  options.jpcenteno-home.desktop.hyprland.hyprscrolling = {
    enable = lib.mkEnableOption ''
      Hyprscrolling plugin for Hyprland.

      Requires restarting Hyprland for changes to take effect.
    '';
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.plugins = [
      pkgs.hyprlandPlugins.hyprscrolling
    ];

    # Required for this plugin to work.
    wayland.windowManager.hyprland.settings = {
      general.layout = "scrolling";

      bind = [
        "$mod, h, layoutmsg, move -col"
        "$mod, l, layoutmsg, move +col"
        "$mod, j, layoutmsg, colresize -0.0.5"
        "$mod, k, layoutmsg, colresize +0.0.5"
        "$mod SHIFT, h, layoutmsg, swapcol l"
        "$mod SHIFT, l, layoutmsg, swapcol r"
      ];

      # Here, `2` means: don't switch keyboard focus when hovering over another
      # window, but do switch focus on click.
      #
      # I added this setting to this module because the scrolling layout makes
      # the default behavior that changes focus on hover extra annoying.
      input.follow_mouse = 2;

      plugin.hyprscrolling = {
        # 0 => Center the column on focus.
        # 1 => Fit the column on focus.
        "focus_fit_method" = 1;
      };
    };
  };
}
