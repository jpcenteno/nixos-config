{
  flake.modules.homeManager.bar =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      gapSize = "16";
      fontSize = "16";
    in
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            position = "top";
            modules-left = [ "hyprland/workspaces" ];
            modules-right = builtins.concatLists [
              [
                "disk"
                "memory"
                "temperature"
                "cpu"
                "network"
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

        style = with config.colorScheme.palette; ''
                  * {
                  font-family: monospace;
                  font-size: ${fontSize}px;
                  }

                  window#waybar {
                  }

                  window#waybar {
                  background-color: rgba(1.0, 1.0, 1.0, 0.0);
                  color: #${base04};
                  }

                  /* Horizontally align waybar with window gaps. */
                  .modules-right { margin-right: ${gapSize}px; }
          #workspaces { margin-left: ${gapSize}px; }

                  .modules-right label,
          #workspaces button
                  {
                  background-color: #${base01};
                  color: #${base04};
                  padding: 0.4rem 1rem;
                  margin-right: 0.5rem;
                  border-radius: 0 0 0.5rem 0.5rem;
                  }

          #workspaces button.focused, #workspaces button.active {
                  background-color: #${base09};
                  color: #${base00};
                  }

          #workspaces button.urgent {
                  background-color: #${base08};
                  color: #${base00};
                  }

          #battery.warning, #battery.critical, #battery.discharging {
                  background-color: #${base08};
                  color: #${base00};
                  }
        '';
      };

      stylix.targets.waybar.enable = false;
    };
}
