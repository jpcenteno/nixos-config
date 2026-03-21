# Declares the systems compatible with this flake.
{ inputs, ... }:
{
  # See https://github.com/nix-systems/nix-systems
  systems = import inputs.systems;
}
