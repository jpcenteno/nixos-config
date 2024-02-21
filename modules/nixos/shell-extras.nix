{ config, pkgs, inputs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
