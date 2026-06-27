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
        # TODO: Maybe move this module to wherever I declared the bluetooth
        # config to prevent the BT module from rendering on computers where
        # bluetooth is not available.
        bluetooth = {
          format-connected = " {num_connections}";
          # TODO: Declare a function at `terminal-emulator.nix` that abstracts
          # the current terminal-emulator from this module.
          # TODO: Declare a constant with the bluetooth manager command in the
          # corresponding module to dissociate this module from bluetooth
          # concerns.
          on-click = "${lib.getExe pkgs.ghostty} --command=${lib.getExe pkgs.bluetuith}";
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
