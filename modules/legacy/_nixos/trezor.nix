{ pkgs, ... }:
{
  # This config was taken from: https://github.com/NixOS/nixpkgs/issues/281975#issuecomment-2028917226

  config = {
    services = {
      trezord = {
        enable = true;
      };
      udev.packages = with pkgs; [ trezor-udev-rules ];
    };
    environment.systemPackages = with pkgs; [
      trezor-suite
      trezorctl
    ];
  };
}
