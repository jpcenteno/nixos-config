{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.brave;
in {
  options.jpcenteno-home.desktop.apps.brave = {
    enable = lib.mkEnableOption "Brave browser";
  };

  config = lib.mkIf cfg.enable {
    programs.brave = {
      enable = true;
      package = lib.mkForce pkgs.brave;
      extensions = builtins.concatLists [
        config.programs.chromium.extensions # Inherit from other modules.
        [
          { id = "jinjaccalgkegednnccohejagnlnfdag"; } # ViolentMonkey
          { id = "pncfbmialoiaghdehhbnbhkkgmjanfhe"; } # uBlacklist
          { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
          { id = "chphlpgkkbolifaimnlloiipkdnihall"; } # OneTab
        ]
      ];
    };
  };
}
