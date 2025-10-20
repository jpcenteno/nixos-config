{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.system.hosts;
in
{
  options.jpcenteno.nixos.system.hosts = {
    enable = lib.mkEnableOption "/etc/hosts configuration.";

    extraBlockLists =
      let
        variants = [
          "fakenews"
          "gambling"
          "porn"
        ];
      in
      lib.mkOption {
        type = lib.types.listOf (lib.types.enum variants);
        default = variants;
        description = "Aditional blocklist extensions";
      };
  };

  config = lib.mkIf cfg.enable {
    networking.stevenblack = {
      enable = lib.mkForce true;
      block = lib.mkForce cfg.extraBlockLists;
    };
  };
}
