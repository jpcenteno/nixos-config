{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno.nixos.system.bluetooth;
in
{
  options.jpcenteno.nixos.system.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support and tools";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    environment.systemPackages = [ pkgs.bluetuith ];
  };
}
