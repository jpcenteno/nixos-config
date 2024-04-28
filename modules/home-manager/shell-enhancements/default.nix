{ config, lib, pkgs, ... }:
let cfg = config.self.shell-enhancements;
in {
  imports = [ ./eza.nix ./direnv.nix ./starship.nix ./bat.nix ];

  options.self.shell-enhancements = {
    enable = lib.mkEnableOption "shell-enhancements";

    # Enable options for packages that don't merit their own module.
    fd.enable = lib.mkEnableOption "fd" // { default = true; };
    fzf.enable = lib.mkEnableOption "fzf" // { default = true; };
    jq.enable = lib.mkEnableOption "jq" // { default = true; };
    ripgrep.enable = lib.mkEnableOption "ripgrep" // { default = true; };
    shellcheck.enable = lib.mkEnableOption "shellcheck" // { default = true; };
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

    programs.bash = {
      # FIXME does this belong here?
      # This is required by `program.starship.enableBashIntegration`, but also
      # required more generally to inherit `home.sessionVariables`, so it might
      # belong in `home.nix` or it's own module.
      enable = true;
      shellAliases = {
        # Standard program replacements.
        cdtmp = ''cd "$(${pkgs.coreutils}/bin/mktemp -d)"'';
      };
    };
  };
}
