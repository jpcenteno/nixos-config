{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.waybar;
in {
  options.jpcenteno-home.waybar = {
    enable = lib.mkEnableOption "Enable waybar";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.waybar;
      description = "Waybar package to use";
    };

    gapSize = lib.mkOption {
      type = lib.types.int;
      default = 16;
      description = "Gap size (In pixels)";
      apply = toString;
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 16;
      description = "Font size (In pixels)";
      apply = toString;
    };

    bluetooth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable the Bluetooth module";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Run Waybar after `programs.waybar.systemd.target` starts. This defaults to
    # `graphical-session.target`. Leaving the mentioned target unchanged should
    # work for different Wayland window mangers.
    programs.waybar.systemd.enable = true;

    programs.waybar = {
      enable = true;
      package = cfg.package;
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
            ]
            (lib.optional cfg.bluetooth.enable "bluetooth")
            [
              "pulseaudio"
              "battery"
              "clock"
            ]
          ];
          clock = { format = "  {:%H:%M}"; };
          battery = {
            interval = 15;
            states = {
              "good" = 95;
              "warning" = 30;
              "critical" = 15;
            };
            format = "{icon}  {capacity}%";
            format-icons = [ "" "" "" "" "" ];
            format-charging = "󰂄 {capacity}%";
          };
          pulseaudio = {
            format = "{icon}  {volume}%";
            format-bluetooth = "{icon}  {volume}%";
            format-muted = "󰝟";
            format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
          };
          cpu = { format = "  {}%"; };
          temperature = {
            format = "{icon} {temperatureC}°C";
            format-icons = [ "" "" "" "" "" ];
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
          memory = { format = "  {}%"; };
          disk = { format = "  {percentage_used}%"; };
          bluetooth = {
            format-connected = " {num_connections}";
            on-click =
              "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bluetuith}/bin/bluetuith";
            tooltip-format = ''
              {controller_alias}	{controller_address}

              {num_connections} connected'';
            tooltip-format-connected = ''
              {controller_alias}	{controller_address}

              {num_connections} connected

              {device_enumerate}'';
            tooltip-format-enumerate-connected =
              "{device_alias}	{device_address}";
            tooltip-format-enumerate-connected-battery =
              "{device_alias}	{device_address}	{device_battery_percentage}%";
          };
        };
      };
      style = with config.colorScheme.palette; ''
        * {
          font-family: monospace;
          font-size: ${cfg.fontSize}px;
        }

        window#waybar {
        }

        window#waybar {
          background-color: rgba(1.0, 1.0, 1.0, 0.0);
          color: #${base04};
        }

        /* Horizontally align waybar with window gaps. */
        .modules-right { margin-right: ${cfg.gapSize}px; }
        #workspaces { margin-left: ${cfg.gapSize}px; }

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
  };
}
