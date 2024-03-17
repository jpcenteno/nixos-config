{ lib, config, pkgs, ... }:

let
  swaySessionSystemdTarget = "sway-session.target";
  palette = config.colorScheme.palette;
  waylockCommand = "${pkgs.waylock}/bin/waylock -fork-on-lock -init-color 0x${palette.base00} -input-color 0x${palette.base0B} -fail-color 0x${palette.base0A}";
in
{
  home.packages = with pkgs; [
    bemenu
    brightnessctl
    waylock
    mpv
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
        { command = "systemctl --user restart ${swaySessionSystemdTarget}"; always = true; }
        { command = "systemctl --user restart waybar"; always = true; }
        { command = "systemctl --user restart swayidle"; always = true; }
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
      input = {
        "type:pointer".natural_scroll = "enabled";
        "type:touchpad" = {
          dwt = "enabled"; # Disable while typing.
          tap = "enabled"; # Tap to click.
          accel_profile = "adaptive";
          pointer_accel = "0.5";
          natural_scroll = "enabled";
        };
      };
    };
    extraConfig = ''
    # Enable touchpad gestures.
    bindgesture swipe:right workspace prev
    bindgesture swipe:left workspace next
    '';
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
          "bluetooth"
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
          format-bluetooth = "{icon}  {volume}%";
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
        bluetooth = {
          format-connected = " {num_connections}";
          on-click = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.bluetuith}/bin/bluetuith";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
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
    systemd.target = swaySessionSystemdTarget;
  };

  services.swayidle = 
  let
    setDisplayStatusCommand = status: "${pkgs.sway}/bin/swaymsg output \"*\" dpms ${status}";
    lockTimeout = 120;
    displayOffTimeout = lockTimeout + 30;
  in
  {
    enable = true;
    systemdTarget = swaySessionSystemdTarget;
    timeouts = [
      { timeout = lockTimeout; command = waylockCommand; }
      { 
        timeout = displayOffTimeout;
        command = "${setDisplayStatusCommand "off"}";
        resumeCommand = "${setDisplayStatusCommand "on"}";
      }
    ];
    events = [
      { event = "before-sleep"; command = waylockCommand; }
      { event = "lock"; command = waylockCommand; }
    ];

    # FIXME:To make sure swayidle waits for swaylock to lock the screen before
    # it releases the inhibition lock, the -w options is used in swayidle, and
    # -f in swaylock. 
  };

  programs.bash = {
    enable = true;
    shellAliases.waylock = waylockCommand;
  };

  fonts.fontconfig.enable = true;
}
