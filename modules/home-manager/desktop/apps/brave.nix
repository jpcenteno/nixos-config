{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.brave-browser;
in
{
  options.jpcenteno-home.desktop.apps.brave-browser = {
    enable = lib.mkEnableOption "Enable Brave browser";

    setAsDefaultBrowser = lib.mkOption {
      type = lib.types.bool;
      description = "Set Brave as the default browser";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.chromium = {
        enable = true;
        package = pkgs.brave;
        # FIXME this will break non-Wayland or non PipeWire hosts.
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
        ];
      };
    }

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
