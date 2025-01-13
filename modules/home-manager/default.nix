{ config, lib, nix-colors, ... }:
let
  cfg = config.jpcenteno-home;
in {
  imports = [
    ./shell/default.nix
    ./desktop/hyprland.nix
    ./development/default.nix
    ./utils/default.nix
    ./system/default.nix
    ./xdg.nix

    nix-colors.homeManagerModules.default
  ];

  options.jpcenteno-home = {
    enable = lib.mkEnableOption "Jpcenteno's home customizations";
  };

  config = lib.mkIf cfg.enable {
    # Set the default color scheme.
    colorScheme = nix-colors.colorSchemes.gruvbox-material-dark-soft;

    # These modules are enabled by default across all my home-manager configs:
    jpcenteno-home.shell.enable = lib.mkDefault true;
    jpcenteno-home.system.enable = lib.mkDefault true;
    jpcenteno-home.utils.enable = lib.mkDefault true;
    jpcenteno-home.development.enable = lib.mkDefault true;
  };
}
