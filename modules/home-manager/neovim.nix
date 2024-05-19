{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Sets $EDITOR.
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    extraPackages = [
      # Test this by running `:checkhealth provider` in vim.
      (pkgs.python3.withPackages (python-packages: [ python-packages.pynvim ]))
    ];
  };
}
