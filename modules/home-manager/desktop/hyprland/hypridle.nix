{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.hyprland.hypridle;

  lockCmd = "${lib.getExe config.programs.hyprlock.package}";
in {
  # NOTE I had to enable `sd-switch` to restart on configuration change.
  #
  # ```nix
  # systemd.user.startServices = "sd-switch";
  # ```

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
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = 0 <= cfg.timeouts.dim-screen;
        message = "jpcenteno-home.desktop.hyprland.hypridle.timeouts.dim-screen must be non-negative.";
      }
      {
        assertion = 0 <= cfg.timeouts.lock-screen;
        message = "jpcenteno-home.desktop.hyprland.hypridle.timeouts.lock-screen must be non-negative.";
      }
    ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof ${lockCmd} || ${lockCmd}";
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = let
          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        in [
          (lib.mkIf (0 < cfg.timeouts.dim-screen) {
            timeout = cfg.timeouts.dim-screen;
            on-timeout = "${brightnessctl} --save set 10%";
            on-resume = "${brightnessctl} --restore";
          })

          (lib.mkIf (0 < cfg.timeouts.lock-screen) {
            timeout = cfg.timeouts.lock-screen;
            on-timeout = "loginctl lock-session";
          })
        ];
      };
    };
  };
}
