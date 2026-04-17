# Installs and configures a desktop screen locker.
#
# The module name is **intentionally generic** so I can decouple other
# configuration modules from whatever application I chose to run as my default
# screen locker.
{
  flake.modules.homeManager.screen-locker =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      colors = with config.colorScheme.palette; {
        background = base00;
        backgroundLighter = base01;
        foreground = base05;
        fail = base08;
        checking = base0A;
      };
    in
    {
      options.screen-locker.shellArgs = lib.mkOption {
        description = ''
          Command and argument list for locking the screen.

          If you need this as a string, use `lib.escapeShellArgs`.
        '';
        type = lib.types.listOf lib.types.str;
        readOnly = true;
        default = [ (lib.getExe config.programs.hyprlock.package) ];
        defaultText = "[ \"<program>\" \"<arg1>\" \"<arg2>\" ]";
      };

      config = {
        programs.hyprlock = {
          enable = true;
          settings = {
            background = lib.mkDefault {
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
    };
}
