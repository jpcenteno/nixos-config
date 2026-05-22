{
  flake.modules.homeManager.openscad =
    { pkgs, ... }:
    {
      # NOTE: As of May 2026, OpenScad hasn't had any stable release since 2021.
      # Prefer `openscad-unstable` to get the cool features like the
      # **Manifold** rendering backend.
      home.packages = with pkgs; [ openscad-unstable ];
    };
}
