{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jpcenteno-home.development.neovim;
in
{
  options.jpcenteno-home.development.neovim = {
    enable = lib.mkEnableOption "Neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true; # Sets $EDITOR.
      viAlias = true;
      vimAlias = true;
      withPython3 = true;

      # These packages are only made available to the Neovim wrapper.
      extraPackages = with pkgs; [
        # Test this by running `:checkhealth provider` in vim.
        (python3.withPackages (python-packages: [ python-packages.pynvim ]))

        gcc # Required by `nvim-treesitter` to build parsers.
        tree-sitter # Required by `nvim-treesitter` to build parsers.
      ];
    };
  };
}
