{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.ai;
in
{
  options.jpcenteno-home.ai = {
    enable = lib.mkEnableOption "all AI-related submodules" // {
      description = ''
        Whether to enable all AI-related submodules.

        When this option is enabled, all current and future submodules under the
        `ai` hierarchy will be enabled by default using `lib.mkDefault`. This
        simplifies setup by activating all configured AI tools.

        You can still override and disable individual submodules explicitly:

        ```nix
        jpcenteno-home.ai = {
          enable = true;
          ollama.enable = false;
        };
        ```
      '';
    };

    cudaSupport = lib.mkEnableOption "CUDA support for AI-related submodules";
  };

  imports = [
    ./ollama.nix
  ];

  config = lib.mkIf cfg.enable {
    jpcenteno-home.ai.ollama = {
      enable = lib.mkDefault true;
      cudaSupport = lib.mkDefault cfg.cudaSupport;
    };
  };
}
