{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno.nixos.nix.substituters;
in
{
  options.jpcenteno.nixos.nix.substituters = {
    enable = lib.mkEnableOption "Nix substituters (Cache servers)";
  };

  config = lib.mkIf cfg.enable {
    nix.settings.substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    # NOTE There is no need to add the trusted key for `cache.nixos.org`.
    nix.settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
