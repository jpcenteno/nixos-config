{
  flake.modules.homeManager.niri = { config, ... }: {
    programs.niri.settings = {
      # Ask applications not to apply client-side decorations.
      prefer-no-csd = true;

      layout.background-color = config.lib.stylix.colors.withHashtag.base00;

      window-rules = [
        {
          geometry-corner-radius =
            let
              floatRadius = 0.0 + config.jpcenteno.aesthetics.cornerRadius;
            in
            {
              # Niri's native configuration syntax accepts a single radius for
              # `geometry-corner-radius` [1], but the Niri flake's corresponding
              # Nix option requires a value for each corner [2]. Expand the
              # single radius into four equal values to preserve uniform corner
              # rounding.
              #
              # [1]: https://niri-wm.github.io/niri/Configuration%3A-Window-Rules.html#geometry-corner-radius
              # [2]: https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettingswindow-rulesgeometry-corner-radius
              bottom-left = floatRadius;
              bottom-right = floatRadius;
              top-left = floatRadius;
              top-right = floatRadius;
            };

          clip-to-geometry = true;

          # Setting this to true will break window transparency.
          draw-border-with-background = false;
        }
        {
          matches = [
            {
              is-active = false;
            }
          ];
          opacity = 0.8;
        }
      ];
    };
  };
}
