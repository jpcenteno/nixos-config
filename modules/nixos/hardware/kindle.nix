{ config, lib, ... }:
let
  cfg = config.jpcenteno.nixos.hardware.kindle;
  group = "kindle";
in
{
  options.jpcenteno.nixos.hardware.kindle = {
    enable = lib.mkEnableOption "Required config for Kindle connection";
  };

  config = lib.mkIf cfg.enable {
    users.groups.${group} = { };

    # Nix should add this rule to `/etc/udev/rules.d/99-local.rules`.
    #
    # Diff the `lsusb (1)` output when the Kindle is plugged and unplugged to
    # find out the `idVendor` and `idProduct` values.
    #
    # To test this rule, unplug and plug your kindle, then run `ls -l /dev/sdX`.
    # You should see the name of the group next to the the user.
    #
    # ```
    # brw-rw---- 1 root kindle 8, 0 Sep 24 02:01 /dev/sdX
    # ```
    #
    services.udev.extraRules = ''
      # Kindle.
      ACTION=="add", SUBSYSTEM=="block", KERNEL=="sd[a-z]", ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0324", MODE="0660", SYMLINK+="kindle", GROUP="${group}"
    '';

    # fileSystems."/mnt/kindle" = {
    #   device = "/dev/kindle";
    #   fsType = "vfat";
    #   options = [ "nofail" "noauto" "user" "umask=000" ];
    # };

    # # Tells Systemd to automount `/dev/kindle`.
    # systemd.automounts = [ { where = "/mnt/kindle"; } ];

    # FIXME this does not belong to this module.
    # FIXME does this strictly require the kindle udev rules?
    services.udisks2.enable = true;
  };
}
