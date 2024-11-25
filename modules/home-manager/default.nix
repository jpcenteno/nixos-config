{ config, lib, nix-colors, ... }:
let
  cfg = config.jpcenteno-home;
in {
  imports = [
    ./shell/default.nix
    ./xdg.nix

    nix-colors.homeManagerModules.default
  ];

  options.jpcenteno-home = {
    enable = lib.mkEnableOption "Jpcenteno's home customizations";
  };

  config = lib.mkIf cfg.enable {
    # Set the default color scheme.
    colorScheme = nix-colors.colorSchemes.rose-pine;

    # These modules are enabled by default across all my home-manager configs:
    jpcenteno-home.shell.enable = lib.mkDefault true;
  };
}
