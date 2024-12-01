{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.system.pam;
in {
  options.jpcenteno.nixos.system.pam = {
    enable = lib.mkEnableOption "PAM modules";
  };

  config = lib.mkIf cfg.enable {
    security.pam.services.hyprlock = {};
  };
}
