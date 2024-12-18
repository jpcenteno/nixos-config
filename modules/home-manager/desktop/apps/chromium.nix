{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.chromium;
in
{
  options.jpcenteno-home.desktop.apps.chromium = {
    enable = lib.mkEnableOption "A Chromium variant with my personal configuration.";

    setAsDefaultBrowser = lib.mkOption {
      type = lib.types.bool;
      description = "Set Chromium as the default browser";
      default = false;
    };

    package = lib.mkPackageOption pkgs "Chromium" {
      default = "brave";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.chromium = {
        enable = true;
        package = cfg.package;
        # FIXME this will break non-Wayland or non PipeWire hosts.
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
        ];
      };
    }

    # FIXME make this configurable or write a wrapper script that allows the
    # user to choose interactively.
    (lib.mkIf cfg.setAsDefaultBrowser {
      xdg.mimeApps.defaultApplications = {
       "text/html" = "brave.desktop";
       "application/xhtml+xml" = "brave.desktop";
       "x-scheme-handler/http" = "brave.desktop";
       "x-scheme-handler/https" = "brave.desktop";
      };
    })
  ]);
}
