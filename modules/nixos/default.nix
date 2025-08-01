{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno.nixos;
in
{
  imports = [
    ./nix/default.nix
    ./system/default.nix
    ./admin/default.nix
  ];
  options.jpcenteno.nixos = {
    enable = lib.mkEnableOption "Jpcenteno's NixOS config";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno.nixos = {
      admin.enable = lib.mkDefault true;
      nix.enable = lib.mkDefault true;
      system.enable = lib.mkDefault true;
    };
  };
}
