{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.nix.garbage-collector;
in
{
  options.jpcenteno.nixos.nix.garbage-collector = {
    enable = lib.mkEnableOption "Garbage collector";
  };

  config = lib.mkIf cfg.enable {
    # Cheatsheet:
    # - Trigger: `sudo systemctl start nix-gc.service`.
    # - Logs: `journalctl -u nix-gc.service`.
    nix.gc = {
      automatic = true;
      randomizedDelaySec = "45min";
      options = "--delete-older-than 15d";
    };
  };
}
