{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.nix.garbage-collector;
in
{
  options.jpcenteno.nixos.nix.garbage-collector = {
    enable = lib.mkEnableOption "Garbage collector";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      gc = {
        # Cheatsheet:
        # - Trigger: `sudo systemctl start nix-gc.service`.
        # - Logs: `journalctl -u nix-gc.service`.
        automatic = true;
        options = "--delete-older-than 15d";
      };

      # The "nix store optimiser" saves up space by replacing identical files
      # with hardlinks.
      optimise.automatic = true;
    };
  };
}
