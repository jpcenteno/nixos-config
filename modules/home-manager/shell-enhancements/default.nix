{ config, lib, pkgs, ... }:
let cfg = config.self.shell-enhancements;
in {
  imports = [ ./eza.nix ./direnv.nix ./starship.nix ./bat.nix ];

  options.self.shell-enhancements = {
    enable = lib.mkEnableOption "shell-enhancements";
  };

  config = lib.mkIf cfg.enable {
    self.shell-enhancements.eza.enable = lib.mkDefault true;
    self.shell-enhancements.direnv.enable = lib.mkDefault true;
    self.shell-enhancements.starship.enable = lib.mkDefault true;
    self.shell-enhancements.bat.enable = lib.mkDefault true;

    home.packages = [ pkgs.fd pkgs.fzf pkgs.jq pkgs.ripgrep pkgs.shellcheck ];

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
