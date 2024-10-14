{ config, lib, ... }:
let cfg = config.jpcenteno-home.shell.extras.starship;
in {

  options.jpcenteno-home.shell.extras.starship = {
    enable = lib.mkEnableOption "Starship";
  };

  config = lib.mkIf cfg.enable {
    # programs.starship = {
    #   enable = true;
    #   # This requires `programs.bash.enable` to be set to `true` to work.
    #   enableBashIntegration = true;
    # };
  };
}
