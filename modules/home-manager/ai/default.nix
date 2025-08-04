{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.ai;
in {
  options.jpcenteno-home.ai = {
    ollama ={
      enable = lib.mkEnableOption "Ollama";
      package = lib.mkPackageOption pkgs "ollama" {};
    };
  };

  config = {
    home.packages = lib.optional cfg.ollama.enable cfg.ollama.package;

    # FIXME make this respect `cfg.ollama.enable`.
    systemd.user.services.ollama = {
      Unit = {
        description = "Ollama LLM daemon";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe cfg.ollama.package} serve";
        Restart = "always";
      };
    };
  };
}
