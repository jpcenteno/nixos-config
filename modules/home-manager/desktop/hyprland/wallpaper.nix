{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.wallpaper;
  wallpaperTargetPath = config.xdg.configFile."wallpaper.jpg".source;
in {
  options.jpcenteno-home.desktop.hyprland.wallpaper = {
    enable = lib.mkEnableOption "Wallpapers";
  };

  config = lib.mkIf cfg.enable {
    # Save wallpapers to XDG_CONFIG_HOME.
    xdg.configFile."wallpaper.jpg".source = ../../../../dotfiles/wallpapers/dark_leaves_gruvbox_material.jpg;

    systemd.user.services.swaybg = {
      Install = { WantedBy = [ "graphical-session.target" ]; };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "swaybg";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
        X-Restart-Triggers =
          [ "${wallpaperTargetPath}" ];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaperTargetPath}";
        Restart = "always";
        RestartSec = "10";
      };
    };

    ## Override Hyprlock config
    programs.hyprlock.settings.background = {
      monitor = "";
      path = "${wallpaperTargetPath}";
    };
  };
}
