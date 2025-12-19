{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.nix.home-manager;
in {
  options.jpcenteno.nixos.nix.home-manager = {
    enable = lib.mkEnableOption "the NixOS settings required by my home-manager config.";
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
      # Required when Home-Manager `xdg.portal.enable` is set to `true`.
      "/share/applications"
      # Required when Home-Manager `xdg.portal.enable` is set to `true`.
      "/share/xdg-desktop-portal"
    ];
  };
}
