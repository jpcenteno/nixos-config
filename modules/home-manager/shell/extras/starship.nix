{
  config,
  lib,
  ...
}: let
  cfg = config.jpcenteno-home.shell.extras.starship;
in {
  options.jpcenteno-home.shell.extras.starship = {
    enable = lib.mkEnableOption "Starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      # Shell integrations.
      enableBashIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;

      settings = {
        # Disable version info.
        bun.disabled = lib.mkDefault true;
        conda.disabled = lib.mkDefault true;
        nodejs.disabled = lib.mkDefault true;

        # Development environments:
        nix_shell.format = "via [$symbol$state]($style) ";
      };
    };
  };
}
