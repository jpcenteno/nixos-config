{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.waylock;
in {
  options.jpcenteno.nixos.waylock = {
    enable = lib.mkEnableOption "Waylock PAM";
  };

  config = lib.mkIf cfg.enable {
    # Necessary for `waylock` to work. Removing the following line will cause the
    # program to reject the correct password.
    security.pam.services.waylock = { };
  };
}
