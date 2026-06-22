{ inputs, ... }:
let
  name = "stylix";
in
{
  flake.modules = {
    nixos.${name} = { pkgs, ... }: {
      imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      };
    };

    homeManager.${name} = { pkgs, ... }: {
      stylix = {
        cursor = {
          package = pkgs.apple-cursor;
          name = "macOS";
          size = 30;
        };

        fonts = {
          emoji = {
            name = "Noto Emoji";
            package = pkgs.noto-fonts-monochrome-emoji;
          };
          monospace = {
            name = "Lilex Nerd Font";
            package = pkgs.nerd-fonts.lilex;
          };
          sansSerif = {
            name = "IBM Plex Sans";
            package = pkgs.ibm-plex;
          };
          serif = {
            name = "IBM Plex Serif";
            package = pkgs.ibm-plex;
          };
        };

        # TODO: Fix conflicts between Stylix and these modules, then remove the
        # corresponding lines:
        targets = {
          alacritty.enable = false;
          fzf.enable = false;
          ghostty.enable = false;
          hyprland.enable = false;
          hyprlock.enable = false;
          tmux.enable = false;
          wofi.enable = false;
        };
      };
    };
  };
}
