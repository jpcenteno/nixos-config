{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.hyprlock;
in {
  options.jpcenteno-home.desktop.hyprland.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = let
      palette = config.colorScheme.palette; 
    in {
      enable = true;
      settings = {
        background = {
          monitor = "";
          color = "rgb(${palette.base00})";

          blur_passes = 0; # Deactivate.
        };

        input-field = {
          monitor = "";
          size = "200,50";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgb(${palette.base05})";
          inner_color = "rgb(${palette.base01})";
          font_color = "rgb(${palette.base05})";
          fade_on_empty = false;
          rounding = -1;
          check_color = "rgb(30, 107, 204)";
          placeholder_text = ''<span foreground="##${palette.base05}">Password</span>'';
          hide_input = false;
          position = "0, -100";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
