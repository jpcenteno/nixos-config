{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.ghostty;
in
{
  options.jpcenteno-home.desktop.apps.ghostty = {
    enable = lib.mkEnableOption "Ghostty";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;

      settings = {
        theme = "base16-dark"; # See custom theme declaration below.
        font-size = 14;
      };

      themes.base16-dark = with config.colorScheme.palette; {
        background = base00;
        foreground = base05;
        selection-background = base02;
        selection-foreground = base05;
        cursor-color = base05;
        palette = [
          "0=#${base00}"
          "1=#${base08}"
          "2=#${base0B}"
          "3=#${base0A}"
          "4=#${base0D}"
          "5=#${base0E}"
          "6=#${base0C}"
          "7=#${base05}"
          "8=#${base03}"
          "9=#${base09}"
          "10=#${base01}"
          "11=#${base02}"
          "12=#${base04}"
          "13=#${base06}"
          "14=#${base0F}"
          "15=#${base07}"
        ];
      };
    };
  };
}
