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

    homeManager.${name} = {
      # TODO: Fix conflicts between Stylix and these modules, then remove the
      # corresponding lines:
      stylix.targets = {
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
}
