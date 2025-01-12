{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.ssh-agent;
in {
  options.jpcenteno-home.ssh-agent = {
    enable = lib.mkEnableOption "SSH-Agent";
  };

  config = lib.mkIf cfg.enable {
    services.ssh-agent.enable = true;
  };
}
