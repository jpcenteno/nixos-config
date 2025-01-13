self: { config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.zen-browser;
in {
  options.jpcenteno-home.desktop.apps.zen-browser = {
    enable = lib.mkEnableOption "Zen Browser";
  };

  config = lib.mkIf cfg.enable {

    home.packages = [
      self.inputs.zen-browser.packages."${pkgs.system}".default
    ];
  };
}
