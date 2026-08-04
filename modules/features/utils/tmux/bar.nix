{
  flake.modules.homeManager.tmux =
    { config, ... }:
    {
      programs.tmux = {
        baseIndex = 1;
        clock24 = true;
        extraConfig =
          with config.lib.stylix.colors.withHashtag;
          let
            bar-bg = base00; # Make it "invisible" WRT the term background.
            bar-fg = base04;

            widget-bg = base01;
            widget-bg-brighter = base02;
            widget-fg = bar-fg;
            highlight-color = base0D;

            widget-highlight = base0A;
          in
          ''
            # Renumber surviving windows after closing one.
            set-option -g renumber-windows on

            # Index at 1 for better keyboard ergonomics.
            set -g base-index 1
            setw -g pane-base-index 1

            set -g status-position top
            set-option -g status-justify "left"

            set-option -g status-left "#[fg=${bar-bg},bg=${widget-highlight}]  #S #[bg=${bar-bg},fg=${bar-fg}] "

            set -g status-style "bg=${bar-bg},fg=${bar-fg}"
            setw -g window-status-format         "#[bg=${widget-bg-brighter},fg=${widget-fg}  ] #I #[bg=${widget-bg}] #W "
            setw -g window-status-current-format "#[bg=${widget-bg-brighter},fg=${highlight-color}] #I #[bg=${widget-bg}] #W "

            set-option -g status-right ""
          '';

      };
    };
}
