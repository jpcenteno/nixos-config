{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.ai.ollama;
in {
  options.jpcenteno-home.ai.ollama = {
    enable = lib.mkEnableOption "Ollama";
    package = lib.mkPackageOption pkgs "ollama" {};
    service.enable = lib.mkEnableOption "Ollama server service" // {
      # FIXME (Mac OS support) Set this to `true` after setting up a service
      # using `launchd`.
      default = pkgs.stdenv.isLinux;
      example = false;
    };

    # FIXME add a shortcut to toggle between the CUDA and non-CUDA version of
    # the Ollama package.
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        # FIXME (Mac OS support) Remove this assertion before implementing
        # an equivalent service for Mac OS using `launchd`.
        assertion = !cfg.service.enable || pkgs.stdenv.isLinux;
        message = "Ollama service is only supported on Linux.";
      }
    ];

    home.packages = [ cfg.package ];

    systemd.user.services.ollama = lib.mkIf (pkgs.stdenv.isLinux && cfg.service.enable) {
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
