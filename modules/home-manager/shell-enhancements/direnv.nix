{ config, lib, ... }:
let cfg = config.self.shell-enhancements.direnv;
in {

  options.self.shell-enhancements.direnv = {
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
