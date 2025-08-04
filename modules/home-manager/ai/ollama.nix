{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.ai.ollama;
in {
  options.jpcenteno-home.ai.ollama = {
    enable = lib.mkEnableOption "Ollama";
    package = lib.mkPackageOption pkgs "ollama" {};
    # FIXME add a shortcut to toggle between the cuda and non-cuda version of
    # the Ollama package.
    # FIXME Add an option to disable the ollama service. 
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.ollama = {
      Unit = {
        Description = "Ollama server";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe cfg.package} serve";
        Restart = "always";
      };
    };
  };
}
