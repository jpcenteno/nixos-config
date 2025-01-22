{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.alacritty;
in
{
  options.jpcenteno-home.alacritty = {
    enable = lib.mkEnableOption "Enables Alacritty";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.attrsets.hasAttrByPath ["colorScheme" "palette"] config;
        message = ''
          Alacritty: No colorscheme found at `config.colorScheme`.

          Use `Misterio77/nix-colors` to set the global colorscheme:

          ```nix
          colorScheme = nix-colors.colorSchemes.everforest;
          ```
          '';
      }
    ];

    programs.alacritty = {
      enable = true;

      # FIXME Figure out a way to template alacritty.toml instead of using the Nix
      # Language wrapper.
      settings = {
        # Reload after rebuild.
        general = {
          live_config_reload = true;
        };

        # Point to the right terminfo entry.
        #
        # As a sidenote, this is required so that Base16 colorschemes don't break
        # under TMUX.
        env = { "TERM" = "alacritty"; };

        window = {
          decorations = "none";
          padding = {
            y = 6;
            x = 8;
          };
          dynamic_padding = true;
        };

        font = {
          size = 14;
          # Use the system's default monospace font, which can be set on
          # `~/.config/fontconfig/fonts.confs`.
          # See: https://wiki.archlinux.org/title/Font_configuration/Examples#The_standard_names
          bold = {
            family = "monospace";
            style = "Bold";
          };
          bold_italic = {
            family = "monospace";
            style = "Bold Italic";
          };
          italic = {
            family = "monospace";
            style = "Italic";
          };
          normal = {
            family = "monospace";
            style = "Regular";
          };
        };

        colors = with config.colorScheme.palette; {
          # The following Base16 mapping for alacritty was taken from:
          # https://github.com/aarowill/base16-alacritty/blob/c95c200b3af739708455a03b5d185d3d2d263c6e/templates/default.mustache
          normal = {
            black = "0x${base00}";
            red = "0x${base08}";
            green = "0x${base0B}";
            yellow = "0x${base0A}";
            blue = "0x${base0D}";
            magenta = "0x${base0E}";
            cyan = "0x${base0C}";
            white = "0x${base05}";
          };
          cursor = {
            text = "0x${base00}";
            cursor = "0x${base05}";
          };
          bright = {
            black = "0x${base03}";
            red = "0x${base09}";
            green = "0x${base01}";
            yellow = "0x${base02}";
            blue = "0x${base04}";
            magenta = "0x${base06}";
            cyan = "0x${base0F}";
            white = "0x${base07}";
          };
          primary = {
            background = "0x${base00}";
            foreground = "0x${base05}";
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
  };
}
