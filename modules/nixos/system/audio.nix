{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.system.audio;
in {
  options.jpcenteno.nixos.system.audio = {
    enable = lib.mkEnableOption "Audio";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };
  };
}
