# NOTE: Importing the Niri module will add `niri.cachix.org` to the cache list,
# but I believe the first time it will build the packages without it.
{ inputs, ... }:
{
  flake.modules.homeManager.niri =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.niri.homeModules.niri
      ];

      programs.niri = {
        enable = true;
        settings = {
          binds =
            let
              action = name: param: {
                action = {
                  ${name} = param;
                };
              };

              wpctl = args: action "spawn" ([ (lib.getExe' pkgs.wireplumber "wpctl") ] ++ args);
              wpctl-set-volume =
                volume:
                wpctl [
                  "set-volume"
                  "--limit"
                  "1.0"
                  "@DEFAULT_AUDIO_SINK@"
                  volume
                ];
              brightness-action =
                lvl:
                action "spawn" [
                  (lib.getExe pkgs.brightnessctl)
                  "set"
                  lvl
                ];
            in
            {
              # Application launching:
              "Mod+Space" = action "spawn" [
                (lib.getExe pkgs.wofi)
                "--show"
                "drun"
              ];

              # Window focusing:
              "Mod+H" = action "focus-column-left" { };
              "Mod+J" = action "focus-workspace-down" { };
              "Mod+K" = action "focus-workspace-up" { };
              "Mod+L" = action "focus-column-right" { };

              # Window moving
              "Mod+Shift+H" = action "move-column-left" { };
              "Mod+Shift+J" = action "move-window-to-workspace-down" { };
              "Mod+Shift+K" = action "move-window-to-workspace-up" { };
              "Mod+Shift+L" = action "move-column-right" { };

              # Jump to workspace by number:
              "Mod+1" = action "focus-workspace" 1;
              "Mod+2" = action "focus-workspace" 2;
              "Mod+3" = action "focus-workspace" 3;
              "Mod+4" = action "focus-workspace" 4;
              "Mod+5" = action "focus-workspace" 5;
              "Mod+6" = action "focus-workspace" 6;
              "Mod+7" = action "focus-workspace" 7;
              "Mod+8" = action "focus-workspace" 8;
              "Mod+9" = action "focus-workspace" 9;

              # Move window to workspace by number:
              "Mod+Shift+1" = action "move-window-to-workspace" 1;
              "Mod+Shift+2" = action "move-window-to-workspace" 2;
              "Mod+Shift+3" = action "move-window-to-workspace" 3;
              "Mod+Shift+4" = action "move-window-to-workspace" 4;
              "Mod+Shift+5" = action "move-window-to-workspace" 5;
              "Mod+Shift+6" = action "move-window-to-workspace" 6;
              "Mod+Shift+7" = action "move-window-to-workspace" 7;
              "Mod+Shift+8" = action "move-window-to-workspace" 8;
              "Mod+Shift+9" = action "move-window-to-workspace" 9;

              # Move workspace to other monitor:
              "Mod+BracketLeft" = action "move-workspace-to-monitor-left" { };
              "Mod+BracketRight" = action "move-workspace-to-monitor-right" { };
              "Mod+Shift+BracketLeft" = action "move-workspace-up" { };
              "Mod+Shift+BracketRight" = action "move-workspace-down" { };

              # Column resizing:
              "Mod+R" = action "switch-preset-column-width" { };
              "Mod+F" = action "maximize-column" { };
              "Mod+Minus" = action "set-column-width" "-10%";
              "Mod+Equal" = action "set-column-width" "+10%";
              "Mod+Shift+Minus" = action "set-window-height" "-10%";
              "Mod+Shift+Equal" = action "set-window-height" "+10%";

              # Danger zone:
              "Mod+Control+Shift+Q" = action "close-window" { };
              "Mod+Control+Shift+E" = action "quit" { };

              # Media control
              "XF86AudioMute" = wpctl [
                "set-mute"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ];
              "XF86AudioRaiseVolume" = wpctl-set-volume "5%+";
              "XF86AudioLowerVolume" = wpctl-set-volume "5%-";
              "Shift+XF86AudioLowerVolume" = wpctl-set-volume "0";

              # Brightness
              "XF86MonBrightnessUp" = brightness-action "+5%";
              "XF86MonBrightnessDown" = brightness-action "5%-";
            };
        };
      };

      programs.waybar.settings.mainBar.modules-left = [ "niri/workspaces" ];
    };
}
