{ pkgs, ... }: {
  home.packages = [ pkgs.tmux ];
  xdg.configFile."tmux/tmux.conf".source = ../../dotfiles/tmux/tmux.conf;
}
