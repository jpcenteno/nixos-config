{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.shell;

  mkEnabledByDefaultOption = name:
    lib.mkEnableOption name // {
      default = true;
    };
in {
  imports = [ ./extras.nix ./direnv.nix ];

  options.jpcenteno-home.shell = {
    enable = lib.mkEnableOption "Shell customizations";

    # Enable options for packages that don't merit their own module.
    fd.enable = mkEnabledByDefaultOption "fd";
    fzf.enable = mkEnabledByDefaultOption "fzf";
    jq.enable = mkEnabledByDefaultOption "jq";
    ripgrep.enable = mkEnabledByDefaultOption "ripgrep";
    shellcheck.enable = mkEnabledByDefaultOption "shellcheck";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno-home.shell.extras.enable = lib.mkDefault true;

    jpcenteno-home.shell.extras.direnv.enable = lib.mkDefault true;

    programs.bash = {
      enable = true; # Every other Bash-related option requires this to be set to `true`.
      bashrcExtra = builtins.readFile ../../../dotfiles/bash/bashrc;
    };

    # NOTE 2024-10-14: This instead of `programs.readline` for simplicity.
    home.file.".inputrc".source = ../../../dotfiles/readline/inputrc;

    home.packages = [
      pkgs.curl
      (lib.mkIf cfg.fd.enable pkgs.fd)
      (lib.mkIf cfg.fzf.enable pkgs.fzf)
      (lib.mkIf cfg.jq.enable pkgs.jq)
      (lib.mkIf cfg.ripgrep.enable pkgs.ripgrep)
      (lib.mkIf cfg.shellcheck.enable pkgs.shellcheck)
    ];
  };
}
