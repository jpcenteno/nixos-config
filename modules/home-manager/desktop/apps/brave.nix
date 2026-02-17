{ config, lib, pkgs, ... }:
let
  cfg = config.jpcenteno-home.desktop.apps.brave;
in {
  options.jpcenteno-home.desktop.apps.brave = {
    enable = lib.mkEnableOption "Brave browser";

    enableChromiumExtensions = lib.mkEnableOption "extensions set by `programs.chromium.extensions`" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    programs.brave = {
      enable = true;
      package = lib.mkForce pkgs.brave;
      extensions = builtins.concatLists [
        (lib.optionals cfg.enableChromiumExtensions config.programs.chromium.extensions)
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
