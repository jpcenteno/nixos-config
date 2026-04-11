# Set's up Flake-Parts flake modules.
{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  # config.flake.modules = lib.mkDefault { };
}
