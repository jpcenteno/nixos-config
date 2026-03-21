{
  config,
  lib,
  ...
}:
let
  cfg = config.jpcenteno-home.system.ssh-agent;
in
{
  options.jpcenteno-home.system.ssh-agent = {
    enable = lib.mkEnableOption "SSH-Agent";
  };

  config = lib.mkIf cfg.enable {
    services.ssh-agent.enable = true;
  };
}
