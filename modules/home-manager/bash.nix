{ config, ... }:

{
  # Prompt editing mode configuration. Mainly to enable vi editing mode.
  xdg.configFile."readline/inputrc".source = ../../dotfiles/readline/inputrc;
  # Keep the home directory clean by moving `inputrc` to `XDG_CONFIG_HOME`.
  home.sessionVariables."INPUTRC" = "${config.xdg.configHome}/readline/inputrc";
}
