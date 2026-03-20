{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno.nixos.system.gpu;
in
{
  options.jpcenteno.nixos.system.gpu = {
    enable = lib.mkEnableOption "GPU hardware config and utilities.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # FIXME Should I move this to home-manager?
      # FIXME Install only what I need.
      nvtopPackages.full
    ];
  };
}
