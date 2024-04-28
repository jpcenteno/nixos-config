{ config, lib, pkgs, ... }:
let cfg = config.self.shell-enhancements;
in {
  imports = [ ./eza.nix ./direnv.nix ];

  options.self.shell-enhancements = {
    enable = lib.mkEnableOption "shell-enhancements";
  };

  config = lib.mkIf cfg.enable {
    self.shell-enhancements.eza.enable = lib.mkDefault true;
    self.shell-enhancements.direnv.enable = lib.mkDefault true;

    home.packages = [ pkgs.fd pkgs.fzf pkgs.jq pkgs.ripgrep pkgs.shellcheck ];

    programs.starship = {
      enable = true;
      # This requires `programs.bash.enable` to be set to `true`.
      enableBashIntegration = true;
    };

    programs.bat = {
      enable = true;
      config = { theme = "base16"; };
    };

    programs.bash = {
      # FIXME does this belong here?
      # This is required by `program.starship.enableBashIntegration`, but also
      # required more generally to inherit `home.sessionVariables`, so it might
      # belong in `home.nix` or it's own module.
      enable = true;
      shellAliases = {
        # Standard program replacements.
        cat = "bat";
        cdtmp = ''cd "$(${pkgs.coreutils}/bin/mktemp -d)"'';
      };
    };
  };
}
