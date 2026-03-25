# NOTE: Importing the Niri module will add `niri.cachix.org` to the cache list,
# but I believe the first time it will build the packages without it.
{ inputs, ... }:
{
  flake.modules = {
    nixos.scrolling-wm = {
      imports = [
      ];
    };

    homeManager.scrolling-wm =
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
                action = action: { inherit action; };
                nullary = name: { ${name} = { }; };
                unary = name: param: { ${name} = param; };

                wpctl = let
                  exe = lib.getExe' pkgs.wireplumber "wpctl";
                in args: action (unary "spawn" ([exe] ++ args));

                wpctl-set-volume = volume: wpctl ["set-volume" "--limit" "1.0" "@DEFAULT_AUDIO_SINK@" volume ];
              in
              {
                # Application launching:
                "Mod+Space" = action (unary "spawn" [ (lib.getExe pkgs.wofi) "--show" "drun" ]);

                # Window focusing:
                "Mod+H" = action (nullary "focus-column-left");
                "Mod+J" = action (nullary "focus-workspace-down");
                "Mod+K" = action (nullary "focus-workspace-up");
                "Mod+L" = action (nullary "focus-column-right");

                # Window moving
                "Mod+Shift+H" = action (nullary "move-column-left");
                "Mod+Shift+J" = action (nullary "move-window-to-workspace-down");
                "Mod+Shift+K" = action (nullary "move-window-to-workspace-up");
                "Mod+Shift+L" = action (nullary "move-column-right");

                # Jump to workspace by number:
                "Mod+1" = action (unary "focus-workspace" 1);
                "Mod+2" = action (unary "focus-workspace" 2);
                "Mod+3" = action (unary "focus-workspace" 3);
                "Mod+4" = action (unary "focus-workspace" 4);
                "Mod+5" = action (unary "focus-workspace" 5);
                "Mod+6" = action (unary "focus-workspace" 6);
                "Mod+7" = action (unary "focus-workspace" 7);
                "Mod+8" = action (unary "focus-workspace" 8);
                "Mod+9" = action (unary "focus-workspace" 9);

                # Move window to workspace by number:
                "Mod+Shift+1" = action (unary "move-window-to-workspace" 1);
                "Mod+Shift+2" = action (unary "move-window-to-workspace" 2);
                "Mod+Shift+3" = action (unary "move-window-to-workspace" 3);
                "Mod+Shift+4" = action (unary "move-window-to-workspace" 4);
                "Mod+Shift+5" = action (unary "move-window-to-workspace" 5);
                "Mod+Shift+6" = action (unary "move-window-to-workspace" 6);
                "Mod+Shift+7" = action (unary "move-window-to-workspace" 7);
                "Mod+Shift+8" = action (unary "move-window-to-workspace" 8);
                "Mod+Shift+9" = action (unary "move-window-to-workspace" 9);

                # Move workspace to other monitor:
                "Mod+BracketLeft" = action (nullary "move-workspace-to-monitor-left");
                "Mod+BracketRight" = action (nullary "move-workspace-to-monitor-right");
                "Mod+Shift+BracketLeft" = action (nullary "move-workspace-up");
                "Mod+Shift+BracketRight" = action (nullary "move-workspace-down");

                # Column resizing:
                "Mod+R" = action (nullary "switch-preset-column-width");
                "Mod+F" = action (nullary "maximize-column");
                "Mod+Minus" = action (unary "set-column-width" "-10%");
                "Mod+Equal" = action (unary "set-column-width" "+10%");
                "Mod+Shift+Minus" = action (unary "set-window-height" "-10%");
                "Mod+Shift+Equal" = action (unary "set-window-height" "+10%");

                # Danger zone:
                "Mod+Control+Shift+Q" = action (nullary "close-window");
                "Mod+Control+Shift+E" = action (nullary "quit");

                # Media control
                "XF86AudioMute" = wpctl ["set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
                "XF86AudioRaiseVolume" = wpctl-set-volume "5%+";
                "XF86AudioLowerVolume" = wpctl-set-volume "5%-";
                "Shift+XF86AudioLowerVolume" = wpctl-set-volume "0";
              };
          };
        };

        programs.waybar.settings.mainBar.modules-left = [ "niri/workspaces" ];
      };
  };
}
