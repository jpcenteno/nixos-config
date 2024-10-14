{ config, lib, pkgs, ... }:
let cfg = config.jpcenteno-home.shell.extras.eza;
in {

  options.jpcenteno-home.shell.extras.eza = { enable = lib.mkEnableOption "Eza"; };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.eza ];

    # NOTE 2024-10-14:
    # Dotfile `../../../dotfiles/bash/bashrc` contains a conditional alias that
    # overrides `ls` with `eza` on interactive shells in case `eza` is
    # available.
  };
}
