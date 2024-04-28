{ config, lib, pkgs, ... }:
let
  cfg = config.self.shell-enhancements;

  mkEnabledByDefaultOption = name:
    lib.mkEnableOption name // {
      default = true;
    };
in {
  imports = [ ./eza.nix ./direnv.nix ./starship.nix ./bat.nix ];

  options.self.shell-enhancements = {
    enable = lib.mkEnableOption "shell-enhancements";

    # Enable options for packages that don't merit their own module.
    fd.enable = mkEnabledByDefaultOption "fd";
    fzf.enable = mkEnabledByDefaultOption "fzf";
    jq.enable = mkEnabledByDefaultOption "jq";
    ripgrep.enable = mkEnabledByDefaultOption "ripgrep";
    shellcheck.enable = mkEnabledByDefaultOption "shellcheck";
  };

  config = lib.mkIf cfg.enable {
    self.shell-enhancements.eza.enable = lib.mkDefault true;
    self.shell-enhancements.direnv.enable = lib.mkDefault true;
    self.shell-enhancements.starship.enable = lib.mkDefault true;
    self.shell-enhancements.bat.enable = lib.mkDefault true;

    home.packages = [
      (lib.mkIf cfg.fd.enable pkgs.fd)
      (lib.mkIf cfg.fzf.enable pkgs.fzf)
      (lib.mkIf cfg.jq.enable pkgs.jq)
      (lib.mkIf cfg.ripgrep.enable pkgs.ripgrep)
      (lib.mkIf cfg.shellcheck.enable pkgs.shellcheck)
    ];
  };
}
