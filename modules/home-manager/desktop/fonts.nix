{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jpcenteno-home.desktop.fonts;
in {
  options.jpcenteno-home.desktop.fonts = {
    enable = lib.mkEnableOption "Enable font customization";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ibm-plex
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
      pkgs.noto-fonts-monochrome-emoji
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Emoji"];
        sansSerif = ["IBM Plex Sans"];
        serif = ["IBM Plex Serif"];
        monospace = ["JetBrainsMono NerdFont"];
      };
    };
  };
}
