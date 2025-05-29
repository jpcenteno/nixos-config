{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.wofi;
in {
  options.jpcenteno-home.desktop.hyprland.wofi = {
    enable = lib.mkEnableOption "Wofi";
  };

  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;

      settings = {
        width=600;
        height=400;
        location="center";
        show="drun";
        prompt="Search...";
        filter_rate=100;
        allow_markup=true;
        no_actions=true;
        halign="fill";
        orientation="vertical";
        content_halign="fill";
        insensitive=true;
        allow_images=true;
        image_size=24;
        gtk_dark=true;
        dynamic_lines=true;
      };

      # See: https://github.com/princejoogie/dotfiles/blob/28276ca726b8a4418660e2f9e38e4ccbc550c839/hyprland/.config/wofi/style.css
      style = let
        border-size = "2px";
        border-color = config.colorScheme.palette.base0A;
        background-color = config.colorScheme.palette.base00;
        text-color = config.colorScheme.palette.base07;
        selection-background = config.colorScheme.palette.base02;
      in ''
        window {
          font-family: "Monospace";
          font-weight: normal;
          font-size: 16px;
          border: ${border-size} solid #${border-color};
          background-color: transparent;
          border-radius: 12px;
        }

        #outer-box {
          border: ${border-size} solid #${border-color};
          border-radius: 12px;
          background-color: #${background-color};
        }

        #input {
          padding: 12px 24px;
          color: #${text-color};
          border-left: none;
          border-right: none;
          border-top: none;
          border-bottom: ${border-size} solid #${border-color};
          outline: none;
          box-shadow: none;
          font-weight: bold;
          background-color: #${background-color};
          outline: none;
          border-bottom-left-radius: 0px;
          border-bottom-right-radius: 0px;
          border-top-right-radius: 12px;
          border-top-left-radius: 12px;
        }

        #inner-box {
          margin: 8px;
          color: #${text-color};
          font-weight: bold;
          background-color: #${background-color};
          border-bottom-left-radius: 12px;
          border-bottom-right-radius: 12px;
        }

        #scroll {
          border: none;
          border-radius: 0px;
        }

        #img {
          margin-right: 6px;
          object-fit: contain;
        }

        #img:selected {
          outline: none;
          box-shadow: none;
        }

        #text:selected {
          outline: none;
          box-shadow: none;
          color: #${text-color};
          border: none;
          border-radius: 0px;
          background-color: #${selection-background};
        }

        #entry {
          padding: 12px;
          outline: none;
          box-shadow: none;
          border: none;
          border-radius: 12px;
          background-color: transparent;
        }

        #entry:selected {
          border-radius: 6px;
          background-color: #${selection-background};
        }
      '';
    };
  };
}
