{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jpcenteno-home.hyprland;

  import-env =
    pkgs.writeShellScriptBin
    "import-env"
    (builtins.readFile ../../../dotfiles/hyprland/import_env.sh);
in {
  imports = [
    ./apps/default.nix
    ./waybar.nix
    ./hyprland/hypridle.nix
    ./hyprland/hyprlock.nix
    ./hyprland/wallpaper.nix
    ./fonts.nix
    ./common/cursor.nix
  ];

  options.jpcenteno-home.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";

    wl-clipboard.enable = lib.mkEnableOption "wl-clipboard" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    jpcenteno-home = {
      waybar.enable = true;
      desktop = {
        apps.enable = lib.mkDefault true;
        common.cursor.enable = lib.mkDefault true;
        fonts.enable = true;
        hyprland = {
          hypridle.enable = lib.mkDefault true;
          hyprlock.enable = lib.mkDefault true;
          wallpaper.enable = lib.mkDefault true;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "${pkgs.alacritty}/bin/alacritty";
        "$menu" = "${pkgs.wofi}/bin/wofi --show drun";

        bind = [
          "$mod, t, exec, $terminal"
          "$mod, return, exec, $terminal"
          "$mod, d, exec, $menu"
          "$mod, space, exec, $menu"
          "$mod, escape, exec, ${config.jpcenteno-home.desktop.hyprland.hyprlock.command}"

          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod&SHIFT, h, movewindoworgroup, l"
          "$mod&SHIFT, j, movewindoworgroup, d"
          "$mod&SHIFT, k, movewindoworgroup, u"
          "$mod&SHIFT, l, movewindoworgroup, r"
          "$mod&SHIFT, left, movewindoworgroup, l"
          "$mod&SHIFT, right, movewindoworgroup, r"
          "$mod&SHIFT, up, movewindoworgroup, u"
          "$mod&SHIFT, down, movewindoworgroup, d"

          # Cycle current workspace through the active monitors.
          "$mod&Shift&Control, h, movecurrentworkspacetomonitor, -1"
          "$mod&Shift&Control, l, movecurrentworkspacetomonitor, +1"

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

          # Window groups:
          "$mod, g, togglegroup"
          "$mod SHIFT, g, lockactivegroup, toggle"
          "$mod, Tab, changegroupactive, f" # Change to the tab on the right.
          "$mod&Shift, Tab, movegroupwindow" # Move tab to the right.

          "$mod SHIFT CONTROL, q, killactive,"
          "$mod SHIFT CONTROL, e, exit,"
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

        misc = {
          # Set wallpaper to the Base16 background color:
          disable_hyprland_logo = "true"; # Required for `background_color` to work.
          disable_splash_rendering = "true"; # Required for `background_color`to work.
          background_color = "0x${config.colorScheme.palette.base00}";
        };

        general = {
          "border_size" = 2;
          "col.inactive_border" = "0xff${config.colorScheme.palette.base03}";
          "col.active_border" = "0xff${config.colorScheme.palette.base0A}";
        };

        group = {
          groupbar = let
            alpha = "58";
          in {
            render_titles = "false";
            scrolling = "false";
            "col.active" = "0x${alpha}${config.colorscheme.palette.base09}";
            "col.locked_active" = "0x${alpha}${config.colorscheme.palette.base09}";
            "col.inactive" = "0x${alpha}${config.colorscheme.palette.base01}";
            "col.locked_inactive" = "0x${alpha}${config.colorscheme.palette.base01}";
          };
        };

        decoration = {
          rounding = "16";
          inactive_opacity = "0.9";
        };

        exec = [
          # Update pre-existing Systemd and TMUX environment with relevant ENV
          # vars set by the desktop environment. For Tmux, this does not affect
          # pre-existing buffers.
          "${import-env}/bin/import-env tmux"
          "${import-env}/bin/import-env system"
        ];
      };
    };

    home.packages = [
      (lib.mkIf cfg.wl-clipboard.enable pkgs.wl-clipboard)
    ];
  };
}
