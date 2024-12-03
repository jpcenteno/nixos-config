{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.common.flatpak;

  # This intercepts the `flatpak` command forcing it to always operate at a user
  # level. This is the intended behavior when Flatpak is installed using Home
  # Manager.
  #
  # This is to prevent two issues that I found:
  #
  # - Packages failing to execute because their `.destkop` entries omit the
  # `--user` flag.
  # - Flatpak complaining that the directory `/var/lib/flatpak/exports/share`
  #   does not exist.
  #
  # I tested what would happen if I pass the `--user` flag twice on a couple of
  # subcommands and the program had no issue with it.
  #
  # FIXME override the `flatpak` package instead of intercepting it to get the
  # man-pages to work.
  flatpakUserWrapper = pkgs.writeShellScriptBin "flatpak" ''
    #! ${pkgs.dash}/bin/dash
    ${pkgs.flatpak}/bin/flatpak --user "$@"
  '';
in {

  options.jpcenteno-home.desktop.common.flatpak = {
    enable = lib.mkEnableOption "flatpak";
  };

  config = lib.mkIf cfg.enable {

    home.packages = [ flatpakUserWrapper ];

    # Make the Flatpak desktop entries discoverable by the host. This directory
    # must be present in the search path defined by the `XDG_DATA_DIRS` for that
    # to happen.
    #
    # NOTE that I'm not including `/var/lib/flatpak/exports/share` here
    # because this home-manager module only deals with user-level packages.
    xdg = {
      enable = lib.mkForce true; # Required for Home Manger to set `XDG_DATA_HOME`. 
      systemDirs.data = [ "${config.xdg.dataHome}/flatpak/exports/share" ];
    };

    home.activation.add-flatpak-remotes = lib.hm.dag.entryAfter
    [ "writeBoundary" ]
    ''
      export PATH="${pkgs.flatpak}/bin:$PATH"
      run flatpak remote-add --user --if-not-exists $VERBOSE_ARG flathub https://dl.flathub.org/repo/flathub.flatpakrepo 
    '';

    # FIXME add an auto-update periodic script.

  };
}
