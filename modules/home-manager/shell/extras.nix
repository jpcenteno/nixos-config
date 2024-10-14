{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.shell.extras;
in {
  options.jpcenteno-home.shell.extras = {
    enable = lib.mkEnableOption "extra shell configuration";

    bat = lib.mkEnableOption "Bat as a cat(1) replacement" // { default = true; };
    eza = lib.mkEnableOption "Eza as a ls(1) replacement" // { default = true; };
    starship = lib.mkEnableOption "Starship shell prompt" // { default = true; };
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

    (lib.mkIf cfg.starship {
      home.packages = [ pkgs.starship ];

      # NOTE 2024-10-14:
      # The code that integrates Starship with bash is located at
      # `../../../dotfiles/bash/bashrc` in order to reduce code complexity and
      # enhance portability with non-NixOS systems
    })
  ]);
}
