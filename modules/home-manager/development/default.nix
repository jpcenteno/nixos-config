{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.development;
in
{
  imports = [
    ./delta.nix
    # FIXME include these:
    # ./github.nix
    # ./nix-lsp.nix
    ./neovim.nix
  ];

  options.jpcenteno-home.development = {
    enable = lib.mkEnableOption "development modules";
  };

  config = lib.mkIf cfg.enable {
    jpcenteno-home.development = {
      delta.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
    };
  };
}
