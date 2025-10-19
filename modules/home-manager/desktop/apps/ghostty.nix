{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.desktop.apps.ghostty;

  reload-ghostty-config =
    let
      src = ./ghostty/reload-ghostty-config.sh;
      binName = "reload-ghostty-config";
      deps = with pkgs; [
        hyprland
        jq
      ];
    in
    pkgs.runCommand "${binName}"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta = {
          mainProgram = "${binName}";
        };
      }
      ''
        mkdir -p $out/bin
        install -m +x ${src} $out/bin/${binName}
        wrapProgram $out/bin/${binName} --prefix PATH : ${lib.makeBinPath deps}
      '';
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

    # NOTE: This runs on every rebuild regardless of whether the Ghostty config
    # has changed or not.
    home.activation.reloadGhosttyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${lib.getExe reload-ghostty-config}
    '';
  };
}
