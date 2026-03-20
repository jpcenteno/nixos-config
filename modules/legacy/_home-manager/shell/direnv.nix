{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.shell.direnv;
in
{
  options.jpcenteno-home.shell.direnv = {
    enable = lib.mkEnableOption "Direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = lib.mkForce true;

      # Enable integrations with a level of "default" to allow the user to opt
      # out. Anyways, each of these depend on the module for each shell to be
      # enabled to work.
      enableBashIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;

      # Nix-direnv is a program that improves the `use nix` and `use flake`
      # startup time by adding a cache for the nix-shell environment and
      # preventing the garbage collector from removing the environment
      # dependencies.
      nix-direnv.enable = lib.mkDefault true;
    };
  };
}
