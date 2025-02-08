{
  config,
  lib,
  ...
}: let
  cfg = config.jpcenteno-home.system;
in {
  imports = [
    ./ssh-agent.nix
  ];

  options.jpcenteno-home.system = {
    enable = lib.mkEnableOption "System tools";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno-home.system.ssh-agent.enable = lib.mkDefault true;
  };
}
