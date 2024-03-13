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
}
