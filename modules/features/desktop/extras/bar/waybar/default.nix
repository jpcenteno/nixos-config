{
  flake.modules.homeManager.bar =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            position = "top";
            # NOTE: Setting `programs.waybar.settings.<bar>.layer = "top"`
            # anchors the bar to the display instead of each individual
            # workspace. This means that it will stay fixed at it's `position`
            # during the workspace change animation.
            layer = "top";
            modules-left = [ "hyprland/workspaces" ];
            modules-right = builtins.concatLists [
              [
                "cpu"
                "memory"
                "temperature"
                "network"
                "disk"
                "bluetooth"
                "pulseaudio"
                "battery"
                "custom/clock"
              ]
            ];
            "custom/clock" = {
              # Reinventing the wheel here to avoid desynchronization issues I was
              # having with `timedatectl`.
              exec = "date '+%H:%M'";
              format = " {}";
              interval = 10;
            };
            battery = {
              interval = 15;
              states = {
                "good" = 95;
                "warning" = 30;
                "critical" = 15;
              };
              format = "{icon}  {capacity}%";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
              format-charging = "󰂄 {capacity}%";
            };
            pulseaudio = {
              format = "{icon}  {volume}%";
              format-bluetooth = "{icon}  {volume}%";
              format-muted = "󰝟";
              format-icons = {
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
              };
            };
            cpu = {
              format = "  {}%";
            };
            temperature = {
              format = "{icon} {temperatureC}°C";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
            };
            network = {
              interval = 10;
              format-wifi = " ";
              format-ethernet = "󰈀";
              tooltip-format-wifi = ''
                 {essid}
                󱑻 {frequency} GHz
                󱄙 {signaldBm} ({signalStrength}%)

                 {ifname}

                ↓ {bandwidthDownBytes}
                ↑ {bandwidthUpBytes}'';
              tooltip-format-ethernet = ''
                 {ifname}

                ↓ {bandwidthDownBytes}
                ↑ {bandwidthUpBytes}'';
            };
            memory = {
              format = "  {}%";
            };
            disk = {
              format = "  {percentage_used}%";
            };
            bluetooth = {
              format-connected = " {num_connections}";
              on-click = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bluetuith}/bin/bluetuith";
              tooltip-format = ''
                {controller_alias}	{controller_address}

                {num_connections} connected'';
              tooltip-format-connected = ''
                {controller_alias}	{controller_address}

                {num_connections} connected

                {device_enumerate}'';
              tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}	{device_address}	{device_battery_percentage}%";
            };
          };
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
            color: @base04; /* Alternate text */
          }

          button {
            /*
              Buttons are used as a label container on the workspaces module.
              I chose to reset their spacing to simplify the stylesheet
              selectors. Margins and paddings are all defined for the contained
              labels instead.
            */
            padding: 0;
            margin: 0;
          }

          label {
            padding: 0.2rem 0.5rem;
            margin-top: 0.4rem;
            border-radius: 8px;
            background-color: @base01; /* Alternate background. */
          }

          .focused label,
          .active label {
            background-color: @base0D; /* Focused window border color. */
            color: @base01;
          }

          .urgent label {
            /* Default text color because we may need more contrast. */
            background-color: @base09; /* Urgent color */
            color: @base01;
          }

          .modules-left button {
            margin-right: 0.75rem;
          }

          .modules-right label {
            margin-left: 0.75rem;
          }

          .modules-left {
            margin-left: 0.75rem;
          }

          .modules-right {
            margin-right: 0.75rem;
          }
        '';
      };

      # Setting this to false to avoid fighting the default style sheet.
      #
      # NOTE Stylix will add some CSS regardless of this setting. I have left
      # another note above the `programs.waybar.style` setting detailing on this
      # matter.
      stylix.targets.waybar.addCss = false;
    };
}
