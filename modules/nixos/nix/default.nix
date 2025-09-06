{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno.nixos.nix;
in
{
  imports = [
    ./garbage-collector.nix
    ./substituters.nix
  ];

  options.jpcenteno.nixos.nix = {
    enable = lib.mkEnableOption "Nix and NixOS configuration";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno.nixos.nix = {
      garbage-collector.enable = lib.mkDefault true;
      substituters.enable = lib.mkDefault true;
    };
  };
}
