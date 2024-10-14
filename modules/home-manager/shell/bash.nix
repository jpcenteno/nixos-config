{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.shell.bash;
in {
  options.jpcenteno-home.shell.bash = {
    enable = lib.mkEnableOption "Bash config";
  };

  config = lib.mkIf cfg.enable {
    # TODO Move this into a "tools" submodule.
    home.packages = [ pkgs.curl ];

    programs.bash = {
      enable = true;
      initExtra = builtins.readFile ../../dotfiles/bash/bashrc;
    };
  };
}
