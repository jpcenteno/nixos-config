{
  flake.modules.homeManager.fzf = { lib, ... }: {
    programs.fzf = {
      enable = true;

      enableBashIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
    };
  };
}
