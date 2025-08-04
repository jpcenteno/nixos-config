{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.ai.ollama;
in
{
  options.jpcenteno-home.ai.ollama = {
    enable = lib.mkEnableOption "Ollama";
    cudaSupport = lib.mkEnableOption "" // {
      description = ''
        Whether to build Ollama with CUDA support. Falls back to default
        behavior defined for the `service.ollama.acceleration` option (See
        `man home-configuration.nix (5)` for reference).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = if cfg.cudaSupport then "cuda" else lib.mkDefault null;
    };
  };
}
