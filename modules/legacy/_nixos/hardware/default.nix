{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.hardware;
in
{
  imports = [
    ./kindle.nix
  ];

  options.jpcenteno.nixos.hardware = {
    enable = lib.mkEnableOption "Hardware config";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno.nixos.hardware.kindle.enable = lib.mkDefault true;
  };
}
