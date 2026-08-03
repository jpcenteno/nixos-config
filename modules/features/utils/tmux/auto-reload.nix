{
  flake.modules.homeManager.tmux =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Emit the "reloaded" notification at the last line of `tmux.conf` as that
      # the message guarantees that the file was correctly sourced.
      programs.tmux.extraConfig = lib.mkAfter ''
        display-message -d 500 "Tmux configuration reloaded."
      '';

      # Only reload on change.
      xdg.configFile."tmux/tmux.conf".onChange = ''
        if ${lib.getExe pkgs.tmux} info 1>/dev/null 2>&1; then
          $DRY_RUN_CMD ${lib.getExe pkgs.tmux} source-file "${config.xdg.configHome}/tmux/tmux.conf"
        fi
      '';
    };
}
