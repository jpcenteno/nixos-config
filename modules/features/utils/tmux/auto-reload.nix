{
  flake.modules.homeManager.tmux =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # NOTE: 2026-08-04 Not using `pkgs.tmuxPlugins.mkTmuxPlugin` because:
      # - This plugin needs to be sourced at the first line from `tmux.conf` and
      # Home manager source plugins after other settings declared by
      # `programs.tmux.*`.
      # - This is way simpler
      tmux-reset = pkgs.fetchFromGitHub {
        owner = "hallazzang";
        repo = "tmux-reset";
        tag = "3.0";
        hash = "sha256-UGzbKrWr+5fz2dcFpRcyftSvUqsJ7ddLLzH0RcHcIhc=";
      };
    in
    {
      programs.tmux = {
        extraConfig = lib.mkMerge [
          (lib.mkAfter ''
            # This needs to be the very last line of `tmux.conf` for the
            # notification to guarantee that the configuration was correctly
            # reloaded.
            display-message -d 500 "Tmux configuration reloaded."
          '')
        ];
      };

      xdg.configFile."tmux/tmux.conf" = {
        # NOTE: Yeah, this feels hacky, but after having read the tmux HM
        # module, I can tell that there's no nicer workaround.
        text = lib.mkOrder 0 ''
          # This needs to be the very first line of `tmux.conf` for the reset to
          # work.
          source-file ${tmux-reset}/tmux-reset
        '';

        # Only reload on change.
        onChange = ''
          if ${lib.getExe pkgs.tmux} info 1>/dev/null 2>&1; then
            $DRY_RUN_CMD ${lib.getExe pkgs.tmux} source-file "${config.xdg.configHome}/tmux/tmux.conf"
          fi
        '';
      };

    };
}
