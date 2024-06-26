# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/46f97c50-e784-4c57-a71f-1eaadb467a02";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-5e4a53ef-ac1a-470a-914c-f22430a81930".device =
    "/dev/disk/by-uuid/5e4a53ef-ac1a-470a-914c-f22430a81930";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F7D4-2C02";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/8b93ce86-a4a5-419f-8233-ad770b528e38"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
