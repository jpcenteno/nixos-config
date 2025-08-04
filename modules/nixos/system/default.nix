{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno.nixos.system;
in
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./pam.nix
    ./gpu.nix
  ];

  options.jpcenteno.nixos.system = {
    enable = lib.mkEnableOption "System/hardware tools and configs.";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno.nixos.system = {
      audio.enable = lib.mkDefault true;
      bluetooth.enable = lib.mkDefault true;
      pam.enable = lib.mkDefault true;
      gpu.enable = lib.mkDefault true;
    };
  };
}
