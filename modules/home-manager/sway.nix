{ lib, config, pkgs, ... }:

let
  swaySessionSystemdTarget = "sway-session.target";
  palette = config.colorScheme.palette;
  waylockCommand = "${pkgs.waylock}/bin/waylock -fork-on-lock -init-color 0x${palette.base00} -input-color 0x${palette.base0B} -fail-color 0x${palette.base0A}";
  gapSizeInPixels = 16;
  desktopBackground = palette.base03;
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
          background = "#${desktopBackground} solid_color";
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
      gaps = { inner = gapSizeInPixels; };
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
    * {
      font-family: monospace;
      font-size: 16px;
    }

    window#waybar {
    }

    window#waybar {
      background-color: #${desktopBackground};
      color: #${base04};
    }

    /* Horizontally align waybar with window gaps. */
    .modules-right { margin-right: ${toString gapSizeInPixels}px; }
    #workspaces { margin-left: ${toString gapSizeInPixels}px; }

    .modules-right label,
    #workspaces button
    {
      background-color: #${base01};
      color: #${base04};
      padding: 4px 16px;
      margin-right: 8px;
      border-radius: 0 0 8px 8px;
    }

    #workspaces button.focused {
      background-color: #${base09};
      color: #${base00};
    }

    #workspaces button.urgent {
      background-color: #${base08};
      color: #${base00};
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

  services.wlsunset = {
    enable = true;
    systemdTarget = swaySessionSystemdTarget;
    temperature.day = 5500;
    temperature.night = 3500;
    latitude = "-34.6";
    longitude = "-58.3";
  };

  programs.bash = {
    enable = true;
    shellAliases.waylock = waylockCommand;
  };

  home.sessionVariables = with palette; {
    BEMENU_OPTS = lib.cli.toGNUCommandLineShell { } {
      ignorecase = true; # match items case insensitively.
      center = true; # Mimic a floating alert window.

      list = 10; # list items vertically with the given number of lines.
      width-factor = 0.33; # defines the relative width factor of the menu (from 0 to 1). (wx)
      fn = "monospace 16"; # defines the font to be used ('name [size]'). (wx)
      border = 2;         # border size in pixels.
      bdr = "#${base09}"; # defines the border color. (wx)
      nb = "#${base00}";  # defines the normal background color. (wx)
      nf = "#${base05}" ; # defines the normal foreground color. (wx)
      ab = "#${base00}";  # defines the alternating background color. (wx)
      af = "#${base05}" ; # defines the alternating foreground color. (wx)
      tb = "#${base09}";  # defines the title background color. (wx)
      tf = "#${base00}" ; # defines the title foreground color. (wx)
      fb = "#${base09}";  # defines the filter background color. (wx)
      ff = "#${base00}" ; # defines the filter foreground color. (wx)
      hb = "#${base09}";  # defines the highlighted background color. (wx)
      hf = "#${base00}";  # defines the highlighted foreground color. (wx)
    };
  };

  fonts.fontconfig.enable = true;
}
