{
  config,
  lib,
  ...
}: let
  cfg = config.jpcenteno-home.utils;
in {
  options.jpcenteno-home.utils = {
    enable = lib.mkEnableOption "Utility programs and their customizations";
  };

  imports = [
    ./file-compression.nix
    ./taskwarrior.nix
    ./lf.nix
  ];

  config = lib.mkIf cfg.enable {
    jpcenteno-home.utils = {
      file-compression.enable = lib.mkDefault true;
      taskwarrior.enable = lib.mkDefault true;
      lf.enable = lib.mkDefault true;
    };
  };
}
