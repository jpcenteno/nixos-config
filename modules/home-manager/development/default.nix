{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.development;
in {
  imports = [
    ./github.nix
  ];

  options.jpcenteno-home.development = {
    enable = lib.mkEnableOption "Enable development submodules";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno-home.development.github.enable = lib.mkDefault true;
  };
}
