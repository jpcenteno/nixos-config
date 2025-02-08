{
  config,
  lib,
  ...
}: let
  cfg = config.jpcenteno.nixos.nix;
in {
  imports = [
    ./substituters.nix
  ];

  options.jpcenteno.nixos.nix = {
    enable = lib.mkEnableOption "Nix and NixOS configuration";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno.nixos.nix.substituters.enable = lib.mkDefault true;
  };
}
