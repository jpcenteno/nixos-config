{
  flake.modules.homeManager.bar = { config, lib, ... }: {
    # Setting this to false to avoid fighting the default style sheet.
    #
    # NOTE Stylix will add some CSS regardless of this setting. I have left
    # another note above the `programs.waybar.style` setting detailing on this
    # matter.
    stylix.targets.waybar.addCss = false;

    programs.waybar = {
      settings.mainBar = {
        position = "top";

        # NOTE: Setting `programs.waybar.settings.<bar>.layer = "top"`
        # anchors the bar to the display instead of each individual
        # workspace. This means that it will stay fixed at it's `position`
        # during the workspace change animation.
        layer = "top";
      };

      # NOTE: Use the GUI debugger to To iterate faster on the CSS:
      #
      # 1. Stop the Waybar service: `systemctl stop --user waybar.service`.
      # 2. Start the GUI debugger: `GTK_DEBUG=interactive waybar`.
      #
      # This will open a window with an object tree and a live CSS editor.
      #
      # NOTE: The Stylix module for Waybar provides definitions for the font
      # size, family and all the @baseXX, colors regardles of the
      # `stylix.targets.waybar.addCss` setting.
      style = lib.mkAfter ''
        * {
          margin: 0;
          padding: 0;
        }

        window {
          background-color: transparent;
        }

        window > box {
          background-color: @base01;
          margin: 0;
          padding: 0px 0px;
        }

        label {
          background-color: @base01;
          color: @base06;
          padding: 0.4rem 0.7rem;
          margin: 0;
        }

        label:hover, button:hover {
          background: @base02;
        }

        .focused label, .active label {
          background-color: @base02;
        }

        #battery.charging {
          color: @base0B;
        }

        /* WARNING */
        label.warning,
        #battery.discharging
        {
          color: @base0A;
        }

        label.urgent,
        label.critical {
          color: @base08;
        }
      '';
    };
  };
}
