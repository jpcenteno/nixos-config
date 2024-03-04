# This module defines the system-wide default fonts. Their purpose is to allow
# me to configure application fonts to use the fallback fonts (`emoji`,
# `sans-serif`, `serif`, `monospace`) to achieve visual uniformity accross
# applications.
#
# A nice thing about Nixos is that it allows me to install the only 3 fonts I
# want.
{ pkgs, ... }:
{
  fonts = {
    packages = [
      pkgs.ibm-plex
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      pkgs.noto-fonts-monochrome-emoji
    ];
    # AFAIK, `home-manager` does not provide this feature, which would be
    # awesome. I should see if I can make a pull request.
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Emoji"];
        sansSerif = [ "IBM Plex Sans" ];
        serif = [ "IBM Plex Serif" ];
        monospace = [ "JetBrainsMono NerdFont" ];
      };
    };
  };

}
