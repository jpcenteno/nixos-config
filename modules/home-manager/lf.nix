{ config, pkgs, ... }: {
  home.packages = [ pkgs.lf ];

  xdg = {
    enable = true;
    configFile = {
      "lf/lfrc".text = ''
        set previewer ${config.xdg.configHome}/lf/previewer.sh
      '';

      "lf/previewer.sh" = {
        executable = true;
        text = ''
          #!/bin/sh

          mime="$( "${pkgs.file}/bin/file" --dereference --brief --mime-type -- "$1" )"
          case "$mime" in
            image/*) "${pkgs.viu}/bin/viu" "$1" ;;
          esac

          # case "$1" in
          #     *.tar*) "${pkgs.gnutar}/bin/tar" tf "$1";;
          #     *.zip) "${pkgs.unzip}/bin/unzip" -l "$1";;
          #     *.rar) "${pkgs.unrar}/bin/unrar" l "$1";;
          #     # *.7z) 7z l "$1";;
          #     # *.pdf) pdftotext "$1" -;;
          #     *) "${pkgs.bat}/bin/bat" "$1";;
          # esac
        '';
      };
    };
  };
}
