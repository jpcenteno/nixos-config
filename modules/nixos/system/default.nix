{
  config,
  lib,
  ...
}: let
  cfg = config.jpcenteno.nixos.system;
in {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./pam.nix
  ];

  options.jpcenteno.nixos.system = {
    enable = lib.mkEnableOption "System/hardware tools and configs.";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno.nixos.system.audio.enable = lib.mkDefault true;
    jpcenteno.nixos.system.bluetooth.enable = lib.mkDefault true;
    jpcenteno.nixos.system.pam.enable = lib.mkDefault true;
  };
}
