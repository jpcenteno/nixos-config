let
  makeGeometryCornerRadius = radius: {
    bottom-left = radius;
    bottom-right = radius;
    top-left = radius;
    top-right = radius;
  };
in
{
  flake.modules.homeManager.niri = { config, ... }: {
    programs.niri.settings = {
      # Ask applications not to apply client-side decorations.
      prefer-no-csd = true;

      layout.background-color = config.lib.stylix.colors.withHashtag.base00;

      window-rules = [
        {
          geometry-corner-radius = makeGeometryCornerRadius 8.0;
          clip-to-geometry = true;
        }
        {
          matches = [
            {
              is-active = false;
            }
          ];
          opacity = 0.75;
        }
      ];
    };
  };
}
