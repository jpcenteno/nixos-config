{ lib, config, pkgs, ... }:

let
  palette = config.colorScheme.palette;
in
{
  home.packages = with pkgs; [
    bemenu
    brightnessctl
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = {
      modifier = "Mod4";
      keybindings = let
          wpctl = "${pkgs.wireplumber}/bin/wpctl";
          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        in lib.mkOptionDefault {
          "XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86MonBrightnessUp" = "exec ${brightnessctl} set +5%";
          "XF86MonBrightnessDown" = "exec ${brightnessctl} set 5%-";
        };
      terminal = "alacritty";
      menu = "bemenu-run";
      focus = {
        followMouse = false;
      };
      window.titlebar = false;
      output = {
        "*" = {
          background = "#${palette.base07} solid_color";
        };
        "eDP-1" = {
          scale = "1";
          mode = "1920x1080";
        };
      };
      bars = []; # Hide default bar. Use `waybar` instead.
      startup = [
        { command = "systemctl --user restart sway-session.target"; always = true; }
        { command = "systemctl --user restart waybar"; always = true; }
      ];
      gaps = { inner = 16; };
      fonts = {
        names = [ "monospace" ];
        size = 12.0;
      };
      colors = {
        focused = {
          background = "#${palette.base09}";
          childBorder = "#${palette.base09}";
          border = "#${palette.base09}";
          indicator = "#${palette.base09}";
          text = "#${palette.base00}";
        };
        focusedInactive = {
          background = "#${palette.base00}";
          childBorder = "#${palette.base00}";
          border = "#${palette.base00}";
          indicator = "#${palette.base00}";
          text = "#${palette.base06}";
        };
        unfocused = {
          background = "#${palette.base00}";
          childBorder = "#${palette.base00}";
          border = "#${palette.base00}";
          indicator = "#${palette.base00}";
          text = "#${palette.base06}";
        };
        urgent = {
          background = "#${palette.base0A}";
          childBorder = "#${palette.base00}";
          border = "#${palette.base00}";
          indicator = "#${palette.base00}";
          text = "#${palette.base00}";
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        modules-left = [ "sway/workspaces" ];
        modules-right = [ 
          "disk"
          "memory"
          "temperature"
          "cpu"
          "pulseaudio"
          "battery"
          "clock"
        ];
        clock = {
          format = "  {:%H:%M}";
        };
        battery = {
          states = { "good" = 95; "warning" = 30; "critical" = 15; };
		format = "{icon}  {capacity}%";
		format-icons = [ "" "" "" "" "" ];
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon}    {volume}%";
          format-muted = "󰝟";
          format-icons = {
              default = ["󰕿" "󰖀" "󰕾"];
          };
        };
        cpu = { format = "  {}%"; };
        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" "" "" ];
        };
        memory = { format = "  {}%"; };
        disk = { format = "  {percentage_used}%"; };
      };
    };
    style = with config.colorScheme.palette; ''
    * { font-family: monospace; font-size: 16px; }
    window#waybar { background-color: #${base00}; color: #${base07}; }
    .modules-right label {
      background-color: #${base07};
      color: #${base00};
      padding: 0 16px;
      margin-right: 16px;
    }
    '';
    systemd.enable = true;
    systemd.target = "sway-session.target";
  };

  fonts.fontconfig.enable = true;
}
