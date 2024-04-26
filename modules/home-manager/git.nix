{ ... }:

{
  programs.git.enable = true;

  xdg.enable = true;
  xdg.configFile."git/config".source = ../../dotfiles/git/config;
  xdg.configFile."git/gitignore".source = ../../dotfiles/git/gitignore;
  xdg.configFile."git/scripts/delete-branches-interactively".source =
    ../../dotfiles/git/scripts/delete-branches-interactively;
}
