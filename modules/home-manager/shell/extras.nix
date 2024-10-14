{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.shell.extras;
in {
  options.jpcenteno-home.shell.extras = {
    enable = lib.mkEnableOption "extra shell configuration";

    bat = lib.mkEnableOption "Bat as a cat(1) replacement" // { default = true; };
    eza = lib.mkEnableOption "Eza as a ls(1) replacement" // { default = true; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.bat {
      home.packages = [ pkgs.bat ];
      xdg.configFile."bat/config".source = ../../../dotfiles/bat/config;

      # NOTE 2024-10-14:
      # Dotfile `../../../dotfiles/bash/bashrc` contains a conditional alias that
      # overrides `cat` with `bat` on interactive shells in case bat is available.
    })

    (lib.mkIf cfg.eza {
      home.packages = [ pkgs.eza ];

      # NOTE 2024-10-14:
      # Dotfile `../../../dotfiles/bash/bashrc` contains a conditional alias
      # that overrides `ls` with `eza` on interactive shells in case `eza` is
      # available.
    })
  ]);
}
