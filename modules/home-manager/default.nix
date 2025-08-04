{
  config,
  lib,
  nix-colors,
  ...
}:
let
  cfg = config.jpcenteno-home;
in
{
  imports = [
    ./shell/default.nix
    ./desktop/hyprland.nix
    ./utils/default.nix
    ./system/default.nix
    ./xdg.nix
    ./ai/default.nix

    nix-colors.homeManagerModules.default
  ];

  options.jpcenteno-home = {
    enable = lib.mkEnableOption "Jpcenteno's home customizations";
  };

  config = lib.mkIf cfg.enable {
    # Set the default color scheme.
    colorScheme = nix-colors.colorSchemes.everforest;

    # These modules are enabled by default across all my home-manager configs:
    jpcenteno-home = {
      shell.enable = lib.mkDefault true;
      system.enable = lib.mkDefault true;
      utils.enable = lib.mkDefault true;
    };
  };
}
