{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [
    pkgs.keyd
  ];

  services.keyd = {
    enable = true;
    keyboards.default.extraConfig = builtins.readFile ./default.conf;
  };

  # Reload `keyd` config after `nixos-rebuild`. `try-restart` prevents a
  # `Failed to restart keyd.service: Unit keyd.service not found.` error from
  # happening the first time `keyd` is activated.
  system.activationScripts.keyd.text = ''
    ${pkgs.systemd}/bin/systemctl try-restart keyd.service
    '';
    #${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:menu
}
