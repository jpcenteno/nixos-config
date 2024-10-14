{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.shell.extras;
in {
  options.jpcenteno-home.shell.extras = {
    enable = lib.mkEnableOption "extra shell configuration";

    bat.enable = lib.mkEnableOption "Bat as a cat(1) replacement" // { default = true; };
    direnv.enable = lib.mkEnableOption "Direnv" // { default = true; };
    eza.enable = lib.mkEnableOption "Eza as a ls(1) replacement" // { default = true; };
    starship.enable = lib.mkEnableOption "Starship shell prompt" // { default = true; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {

      # NOTE 2024-10-14: See `~/.bashrc` for bash integration:
      #
      # The dotfile `../../../dotfiles/bash/bashrc` includes many overriding
      # configurations and activation scripts which I decided not to handle
      # using the home-manager options. The rationale for this decision was to
      # reduce code complexity and improve compatibility with non-NixOS systems.
      #
      # This may include:
      # - A conditional `alias ls=eza`
      # - A conditional `alias cat=bat`
      # - Starship integration.
      # - Direnv integration.

      home.packages = [
        (lib.mkIf cfg.bat.enable pkgs.bat)
        (lib.mkIf cfg.eza.enable pkgs.eza)
        (lib.mkIf cfg.starship.enable pkgs.starship)
      ];

      xdg.configFile."bat/config" = {
        enable = cfg.bat.enable;
        source = ../../../dotfiles/bat/config;
      };

      programs.direnv = {
        enable = cfg.direnv.enable;
        # Nix-direnv is a program that improves the `use nix` and `use flake`
        # startup time by adding a cache for the nix-shell environment and
        # preventing the garbage collector from removing the environment
        # dependencies.
        nix-direnv.enable = cfg.direnv.enable;
      };
    }
  ]);
}
