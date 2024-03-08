# > A custom version of Firefox, focused on privacy, security and freedom.
# >
# > LibreWolf is designed to increase protection against tracking and
# > fingerprinting techniques, while also including a few security improvements.
# > This is achieved through our privacy and security oriented settings and
# > patches. LibreWolf also aims to remove all the telemetry, data collection
# > and annoyances, as well as disabling anti-freedom features like DRM.
# >
# > From https://librewolf.net/

{ ... }:
{
  programs.librewolf = {
    enable = true;
    settings = {
      # Hide the bookmarks toolbar.
      "browser.toolbars.bookmarks.visibility" = "never";
      # Disable the translations feature.
      "browser.translations.automaticallyPopup" = false;
      "browser.translations.enable" = false;
    };
  };

  # Taken from [1].
  # [1]:  https://github.com/ngkz/dotfiles/blob/941fcbc7f30dab2254e744e187476648423ca922/home/workstation/librewolf/default.nix#L17
  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "text/xml" = "librewolf.desktop";
    "application/xhtml+xml" = "librewolf.desktop";
    "application/vnd.mozilla.xul+xml" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
  };
}
