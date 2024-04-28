{ config, lib, ... }:
let cfg = config.self.shell-enhancements.starship;
in {

  options.self.shell-enhancements.starship = {
    enable = lib.mkEnableOption "Starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      # This requires `programs.bash.enable` to be set to `true` to work.
      enableBashIntegration = true;
    };
  };
}
