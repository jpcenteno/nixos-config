{ config, lib, ... }:
let
  cfg = config.jpcenteno-home;
in {
  imports = [
    ./shell/default.nix
    ./xdg.nix
  ];

  options.jpcenteno-home = {
    enable = lib.mkEnableOption "Jpcenteno's home customizations";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno-home.shell.enable = lib.mkDefault true;
  };
}
