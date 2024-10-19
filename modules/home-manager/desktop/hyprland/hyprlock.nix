{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.hyprlock;

  colors = with config.colorScheme.palette; {
    background = base00;
    backgroundLighter = base01;
    foreground = base05;
    fail = base08;
    checking = base0A;
  };
in {
  options.jpcenteno-home.desktop.hyprland.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock";

    package = lib.mkPackageOption pkgs "hyprlock" { };

    command = lib.mkOption {
      description = "Command to execute a singleton instance of Hyprlock";
      type = lib.types.str;
      default = "${pkgs.procps}/bin/pidof ${lib.getExe cfg.package} || ${lib.getExe cfg.package}";
      readOnly = true; # Provide external R/O access to this value.
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          monitor = ""; # Apply to every monitor.
          color = "rgb(${colors.background})";

          blur_passes = 0; # Deactivate.
        };

        input-field = {
          # Positioning:
          monitor = ""; # Apply to every monitor.
          size = "200,50";
          position = "0, -100";
          halign = "center";
          valign = "center";

          fade_on_empty = false;

          # Prompt:
          inner_color = "rgb(${colors.backgroundLighter})";
          hide_input = false;
          rounding = 0;

          # Prompt (Waiting for password):
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgb(${colors.foreground})";
          font_color = "rgb(${colors.foreground})";
          placeholder_text = ''<span foreground="##${colors.foreground}">Password</span>'';

          # Prompt (checking password):
          check_color = "rgb(${colors.checking})";

          # Prompt (Failure):
          fail_color = "rgb(${colors.fail})"; # Changes outer_color and fail message color
          fail_text = "$FAIL #$ATTEMPTS"; # `$FAIL` = PAM fail reason.
        };
      };
    };
  };
}
