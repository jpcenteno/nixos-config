{
  flake.modules.homeManager.niri = {
    programs.niri.settings = {
      # Ask applications not to apply client-side decorations.
      prefer-no-csd = true;
    };
  };
}
