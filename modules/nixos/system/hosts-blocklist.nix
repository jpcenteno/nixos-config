{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.system.hosts-blocklist;
in
{
  options.jpcenteno.nixos.system.hosts-blocklist = {
    enable = lib.mkEnableOption "Hosts-level domain blocking";

    extraBlockLists =
      let
        variants = [
          "fakenews"
          "gambling"
          "porn"
          "social"
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
