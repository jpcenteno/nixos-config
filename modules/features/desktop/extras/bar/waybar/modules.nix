{
  flake.modules.homeManager.bar =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.waybar.settings.mainBar = {
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
}
