{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.desktop.hyprland.hypridle;

  mkListener = { timeout, ... }@attrs: (lib.mkIf (0 < timeout) attrs);

  mkTimeoutAssertion = attrName: {
    assertion = 0 <= cfg.timeouts."${attrName}";
    message = "Hypridle: Timeout `${attrName}` must be non-negative!";
  };

  lockSessionCmd = "${pkgs.systemd}/bin/loginctl lock-session";
in
{
  # NOTE I had to enable `sd-switch` to restart on configuration change.
  #
  # ```nix
  # systemd.user.startServices = "sd-switch";
  # ```

  imports = [ ./hyprlock.nix ];

  options.jpcenteno-home.desktop.hyprland.hypridle = {
    enable = lib.mkEnableOption "Hypridle";

    timeouts = {
      dim-screen = lib.mkOption {
        description = "Dim screen after `n` seconds. Set to 0 to deactivate";
        default = 55;
        type = lib.types.int;
      };

      lock-screen = lib.mkOption {
        description = "Lock screen after `n` seconds. Set to 0 to deactivate";
        default = 60;
        type = lib.types.int;
      };

      screen-off = lib.mkOption {
        description = "Turn screen off after `n` seconds. Set to 0 to deactivate";
        default = 80;
        type = lib.types.int;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (mkTimeoutAssertion "dim-screen")
      (mkTimeoutAssertion "lock-screen")
      (mkTimeoutAssertion "screen-off")
    ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = config.jpcenteno-home.desktop.hyprland.hyprlock.command;
          before_sleep_cmd = "${lockSessionCmd}"; # lock before suspend.
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          (mkListener {
            timeout = cfg.timeouts.dim-screen;
            on-timeout = "${lib.getExe pkgs.brightnessctl} --save set 10%";
            on-resume = "${lib.getExe pkgs.brightnessctl} --restore";
          })

          (mkListener {
            timeout = cfg.timeouts.lock-screen;
            on-timeout = "${lockSessionCmd}";
          })

          (mkListener {
            timeout = cfg.timeouts.screen-off;
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          })
        ];
      };
    };
  };
}
