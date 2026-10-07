{
  flake.modules.nixos.flatpak = { pkgs, ... }: {
    assertions = [
      {
        assertion = pkgs.stdenv.isLinux;
        message = "Flatpak is only supported on Linux.";
      }
    ];

    services.flatpak.enable = true;
  };
}
