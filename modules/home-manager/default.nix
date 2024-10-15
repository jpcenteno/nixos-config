{ config, lib, ... }:
let
  cfg = config.jpcenteno-config;
in {
  imports = [ ./xdg.nix ];
}
