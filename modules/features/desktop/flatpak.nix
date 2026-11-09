{
  flake.modules = {
    nixos.flatpak = { pkgs, ... }: {
      assertions = [
        {
          assertion = pkgs.stdenv.isLinux;
          message = "Flatpak is only supported on Linux.";
        }
      ];

      services.flatpak.enable = true;
    };

    homeManager.aesthetics = {
      # NOTE: It is reasonable to place this cross-concern config here, at the
      # `aesthetics` module because:
      # - The `aesthetics` module guarantees that the `stylix` module is
      #   available.
      # - This configuration will only apply if other module sets
      # `services.flatpak.enable = true;`.
      stylix.targets.gtk.flatpakSupport.enable = false; # FIXME remove this and fix underlying issue!!!!
    };
  };
}
