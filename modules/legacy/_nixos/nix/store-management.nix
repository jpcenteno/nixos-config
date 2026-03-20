{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.nix.store-management;
in
{
  options.jpcenteno.nixos.nix.store-management = {
    enable = lib.mkEnableOption "Nix store management jobs";
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
