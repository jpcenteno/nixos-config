# Installs and configures a GUI terminal emulator.
#
# The module name is **intentionally generic** so I can decouple other
# configuration modules from whatever application I chose to run as my default
# terminal emulator.
{
  flake.modules.homeManager.terminal-emulator = { config, lib, pkgs, ... }: {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;

      settings = {
        theme = "base16-dark"; # See custom theme declaration below.

        # Changing the system's default font does not automatically update
        # Ghostty's font. To apply a new font, its name must be updated here.
        font-family = lib.head config.fonts.fontconfig.defaultFonts.monospace;
        font-size = 16;
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

    home.activation.reload-ghostty-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if "${lib.getExe' pkgs.procps "pgrep"}" ghostty >/dev/null; then
        run "${lib.getExe' pkgs.procps "pkill"}" -SIGUSR2 ghostty
      fi
    '';
  };
}
