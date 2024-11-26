{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos;
in {
  imports = [
    ./nix/default.nix
    ./system/default.nix
  ];
  options.jpcenteno.nixos = {
    enable = lib.mkEnableOption "Jpcenteno's NixOS config";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno.nixos.nix.enable = lib.mkDefault true;
    jpcenteno.nixos.system.enable = lib.mkDefault true;
  };
}