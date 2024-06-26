{ config, ... }: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      source-file ${config.xdg.configHome}/tmux/general.conf
      source-file ${config.xdg.configHome}/tmux/base16.conf
    '';
  };

  xdg.configFile = {
    "tmux/general.conf".source = ../../dotfiles/tmux/general.conf;
    "tmux/base16.conf".source = ../../dotfiles/tmux/base16.conf;
  };
}
