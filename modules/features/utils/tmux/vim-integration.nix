{
  flake.modules.homeManager.tmux = { pkgs, ... }: {
    programs.tmux.plugins = [
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
  };
}
