{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno.nixos.admin;
in
{
  options.jpcenteno.nixos.admin = {
    enable = lib.mkEnableOption "Admin tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      usbutils # Provides lsusb usb-devices usbhid-dump usbreset.

      # Networking tools
      tcpdump
      dig
      gping
      bandwhich

      # Process monitoring
      htop
      btop
      bottom
    ];
  };
}
