{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.development.delta;
in {
  options.jpcenteno-home.development.delta = {
    enable = lib.mkEnableOption "the Delta syntax highlighter";
  };

  config = lib.mkIf cfg.enable {
    programs.git.delta.enable = true;
  };
}
