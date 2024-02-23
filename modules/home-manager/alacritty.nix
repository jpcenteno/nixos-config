{ config, ... }:
{
  programs.alacritty = {
    enable = true;

    # FIXME Figure out a way to template alacritty.toml instead of using the Nix
    # Language wrapper.
    settings = {
      # Reload after rebuild.
      live_config_reload = true;

      env = {
        "TERM" = "xterm";
      };

      window = {
        columns = 110;
        rows = 50;
        decorations = "none";
        padding = { y = 24; x = 8; };
        dynamic_padding = true;
      };

      font = {
        size = 16;
      };

      colors = with config.colorScheme.colors; {
        bright = {
          black = "0x${base02}";
          blue = "0x${base0D}";
          cyan = "0x${base0C}";
          green = "0x${base0B}";
          magenta = "0x${base0E}";
          red = "0x${base08}";
          white = "0x${base06}";
          yellow = "0x${base09}";
        };
        cursor = {
          cursor = "0x${base06}";
          text = "0x${base06}";
        };
        normal = {
          black = "0x${base02}";
          blue = "0x${base0D}";
          cyan = "0x${base0C}";
          green = "0x${base0B}";
          magenta = "0x${base0E}";
          red = "0x${base08}";
          white = "0x${base06}";
          yellow = "0x${base0A}";
        };
        primary = {
          background = "0x${base00}";
          foreground = "0x${base07}";
        };
      };

    };
  };

  xdg.desktopEntries."Alacritty" = {
    name = "Alacritty";
    comment = "Terminal emulator";
    icon = "Alacritty";
    exec = "alacritty";
    categories = [ "System" "TerminalEmulator" ];
    terminal = false;
    mimeType = [ "text/plain" ];
  };
}
