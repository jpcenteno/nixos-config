{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.utils.yazi;
in {
  options.jpcenteno-home.utils.yazi = {
    enable = lib.mkEnableOption "Yazi";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;

      enableBashIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;

      shellWrapperName = "y";

      settings = {
        plugin = {
          prepend_previewers = [
            # Chrome extensions:
            { name = "*.crx"; run = "archive"; }
          ];
        };
      };
    };
  };
}
