{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.utils;
in {
  options.jpcenteno-home.utils = {
    enable = lib.mkEnableOption "Utility programs and their customizations";
  };

  imports = [
    ./taskwarrior.nix
    ./lf.nix
  ];

  config = lib.mkIf cfg.enable {
    jpcenteno-home.utils.taskwarrior.enable = lib.mkDefault true;
    jpcenteno-home.utils.lf.enable = lib.mkDefault true;
  };
}
