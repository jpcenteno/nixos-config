{ pkgs, lib, config, ... }:

let
  cfg = config.asus-linux;
in
{
  options = {
    asus-linux = {
      enable = lib.mkEnableOption (lib.mdDoc "Enables services for Asus ROG laptops");
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.buildPlatform.system == "x86_64-linux";
        message = "Trying to use the asus-linux module outside the x86_64-linux platform";
      }
    ];
  };
}
