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
            image/*)           "${pkgs.viu}/bin/viu" "$1"        ;;
            application/zip)   "${pkgs.unzip}/bin/unzip" -l "$1" ;;
            application/x-rar) "${pkgs.unrar}/bin/unrar" l "$1"  ;;
            application/x-tar) "${pkgs.gnutar}/bin/tar" -tf "$1" ;;
            *)                 "${pkgs.bat}/bin/bat" "$1"        ;;
          esac
        '';
      };
    };
  };
}
