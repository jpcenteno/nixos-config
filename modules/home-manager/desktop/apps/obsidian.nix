{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.obsidian;
in {
  options.jpcenteno-home.desktop.apps.obsidian = {
    enable = lib.mkEnableOption "Obsidian";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ];

    # This solves a problem with the Obsidian Web Clipper where only the title
    # of the note was being saved, but neither the content, nor the frontmatter
    # were being written to it.
    #
    # Note that this is a Hyprland-specific solution and this setting will only
    # take effect when `wayland.windowManager.hyprland.enable` is set to `true`.
    #
    # https://help.obsidian.md/web-clipper/troubleshoot#Obsidian+opens+but+only+the+file+name+is+saved
    #
    # FIXME Replace this with a rule that only applies to Obsidian, so that this
    # module does not affect Hyprland preferences in general.
    wayland.windowManager.hyprland.settings.misc.focus_on_activate = true;
  };
}
