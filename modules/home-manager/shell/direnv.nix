{ config, lib, ... }:
let cfg = config.jpcenteno-home.shell.extras.direnv;
in {

  options.jpcenteno-home.shell.extras.direnv = {
    enable = lib.mkEnableOption "Direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      # Caches the nix-shell environment reducing the waiting time after first run
      # and prevents garbage collection of build dependencies.
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
  };
}
