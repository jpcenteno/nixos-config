{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.keyd;
in
{
  options.keyd = {
    enable = lib.mkEnableOption "Enable Keyd";
  };

  config = lib.mkIf cfg.enable {
    # environment.systemPackages = [ pkgs.keyd ];

    services.keyd = {
      enable = true;
      keyboards.default.extraConfig = builtins.readFile ../../dotfiles/keyd/default.conf;
    };

    # Reload `keyd` config after `nixos-rebuild`.

    # `try-restart` prevents a `Failed to restart keyd.service: Unit
    # keyd.service not found.` error from happening the first time `keyd` is
    # activated.
    system.activationScripts.keyd.text = ''
      ${pkgs.systemd}/bin/systemctl try-restart keyd.service
    '';
  };
}
