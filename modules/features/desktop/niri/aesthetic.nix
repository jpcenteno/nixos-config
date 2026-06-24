let
  makeGeometryCornerRadius = radius: {
    bottom-left = radius;
    bottom-right = radius;
    top-left = radius;
    top-right = radius;
  };
in
{
  flake.modules.homeManager.niri = {
    programs.niri.settings = {
      # Ask applications not to apply client-side decorations.
      prefer-no-csd = true;

      window-rules = [
        {
          geometry-corner-radius = makeGeometryCornerRadius 8.0;
          clip-to-geometry = true;
        }
      ];
    };
  };
}
