{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.chromium;

  ungoogledChromiumFlags = [

    # Prompt for install when downloading Chromium extensions (`.crx`
    # files) or User Scripts.
    #
    # This is required for installing `NeverDecaf/chromium-web-store`.
    #
    # ## Relevant documentation:
    #
    # > Change how extension MIME types (CRX and user scripts) are
    # > handled. Acceptable values are `download-as-regular-file` or
    # > `always-prompt-for-install`. Leave unset to use normal behavior.
    # >
    # > -- https://github.com/ungoogled-software/ungoogled-chromium/blob/master/docs/flags.md
    #
    # > Handling of extension MIME type requests
    # > Used when deciding how to handle a request for a CRX or User
    # > Script MIME type. ungoogled-chromium flag. – Mac, Windows,
    # > Linux, ChromeOS, Android, Lacros.
    # >
    # > -- chrome://flags/#extension-mime-request-handling
    #
    # ## How to Debug:
    #
    # 1. Relaunch `ungoogled-chromium`.
    # 2. Check `chrome://flags/#extension-mime-request-handling`.
    "--extension-mime-request-handling=always-prompt-for-install"

  ];

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
      default = "ungoogled-chromium";
    };

    # FIXME autodetect ungoogled chromium or throw a warning, IDK.
    enableUngoogledChromiumFlags = lib.mkEnableOption "Ungoogled-chromium specific flags";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.chromium = {
        enable = true;
        package = cfg.package;
        # FIXME this will break non-Wayland or non PipeWire hosts.
        commandLineArgs = lib.concatLists [
          [
            "--ozone-platform=wayland"
            "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
          ]

          (lib.optionals cfg.enableUngoogledChromiumFlags ungoogledChromiumFlags)
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
