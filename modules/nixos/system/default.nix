{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.system;
in {
  imports = [
    ./bluetooth.nix
  ];

  options.jpcenteno.nixos.system = {
    enable = lib.mkEnableOption "System/hardware tools and configs.";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno.nixos.system.bluetooth.enable = lib.mkDefault true;
  };
}
