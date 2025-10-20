{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.system.hosts;
in
{
  options.jpcenteno.nixos.system.hosts = {
    enable = lib.mkEnableOption "/etc/hosts configuration.";

    blockedDomains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Locally defined list of blocked domains.";
      example = lib.literalExpression ''
        [
          "example.org"
          "foobar.example"
        ]
      '';
    };

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
    networking = {
      hosts."0.0.0.0" = cfg.blockedDomains;

      stevenblack = {
        enable = lib.mkForce true;
        block = lib.mkForce cfg.extraBlockLists;
      };
    };
  };
}
