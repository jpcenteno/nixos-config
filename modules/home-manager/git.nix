{ ... }:

{
  programs.git.enable = true;

  xdg.enable = true;
  xdg.configFile."git/config".source = ../../dotfiles/git/config;
  xdg.configFile."git/gitignore".source = ../../dotfiles/git/gitignore;
}
