{ config, lib, ... }:
let cfg = config.self.shell-enhancements.bat;
in {

  options.self.shell-enhancements.bat = { enable = lib.mkEnableOption "Bat"; };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = { theme = "base16"; };
    };

    programs.bash.shellAliases.cat = "bat";
  };
}
