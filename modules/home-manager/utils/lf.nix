{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.utils.lf;
in
{
  options.jpcenteno-home.utils.lf = {
    enable = lib.mkEnableOption "LF - Terminal file manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.lf ];

    xdg = {
      enable = true;
      configFile = {
        "lf/icons".source = ../../../dotfiles/lf/icons;

        "lf/lfrc".text = ''
          set icons true

          set previewer ${config.xdg.configHome}/lf/previewer.sh

          map gc cd ~/Code/
          map gd cd ~/Downloads/
          map gD cd ~/Documents/
          map gb cd ~/Documents/Bib/
          map gf cd ~/Documents/finance/
          map gn cd ~/Documents/Notes/
          map gp cd ~/Documents/Projects/
          map gr cd ~/Documents/Reference/
          map R !${pkgs.massren}/bin/massren $fx
        '';

        "lf/previewer.sh" = {
          executable = true;
          text = ''
            #!/bin/sh

            # Glow will clutter the preview with the URLs
            remove_terminal_hyperlinks() {
                '${pkgs.perl}/bin/perl' -pe 's/\x1b\x5d\x38\x3b\x3b.*?\x1b\x5c//g'
            }

            mime="$( "${pkgs.xdg-utils}/bin/xdg-mime" query filetype "$1" )"
            case "$mime" in
              image/*)           "${pkgs.viu}/bin/viu" "$1"        ;;
              application/zip)   "${pkgs.unzip}/bin/unzip" -l "$1" ;;
              application/x-rar) "${pkgs.unrar}/bin/unrar" l "$1"  ;;
              application/x-tar) "${pkgs.gnutar}/bin/tar" -tf "$1" ;;
              application/json)  "${pkgs.jq}/bin/jq" --color-output . "$1" ;;
              text/markdown)     "${pkgs.mdcat}/bin/mdcat" "$1" | remove_terminal_hyperlinks ;;
              *)                 "${pkgs.bat}/bin/bat" --style=plain --color always "$1" ;;
            esac
          '';
        };
      };
    };
  };
}
