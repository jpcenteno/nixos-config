/*

This module configures the system registry to pin the flake names to the
versions specified in the flake.lock file. This ensures that the registry
remains consistent with this configuration file.

## The Flake Registry

The flake registry is a name resolver that allows you to refer to flake URLs
using symbolic identifiers (e.g., when you run `nix run nixpkgs#hello`).

Without pinning flakes to the system registry, flake names will resolve to
the latest version as specified in the global registry fetched from the internet.
This module provides deterministic pinning and prevents unnecessary downloads
due to cache misses.

## Problems Addressed

- **Non-Deterministic Version Resolution**: Without proper local registry
  configuration, flakes may resolve to different versions declared in the global
  registry, leading to inconsistencies with this configuration flake.
- **Frequent Cache Updates**: A lack of local registry configuration can result
  in frequent cache updates from the global registry, consuming unnecessary time
  and bandwidth.

*/
{ config, inputs, lib, ... }:
with lib;
let
  cfg = config.pin-input-flakes-to-system-registry;
in
{

  options = {
    pin-input-flakes-to-system-registry = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Wether to pin the system flake registry to the same inputs used
          by this configuration flake.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    nix.registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-unstable.flake = inputs.unstable-nixpkgs;
      home-manager.flake = inputs.home-manager;
    };
  };
}
