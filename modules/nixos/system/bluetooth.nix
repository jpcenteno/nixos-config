{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.system.bluetooth;
in {
  options.jpcenteno.nixos.system.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support and tools";
  };

  config = lib.mkIf cfg.enable {
    # FIXME 2024-11-26 This is for tracing purposes. Delete when done debugging.
    warnings = [ "config.jpcenteno.nixos.system.bluetooth is enabled!" ];
  };
}
