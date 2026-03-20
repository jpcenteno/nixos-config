# Configures code formatting for this flake.
#
# ## USAGE:
#
# `nix fmt`                Fix format.
# `nix fmt -- --ci`        Check format.
{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    programs.nixfmt.enable = true;
  };
}
