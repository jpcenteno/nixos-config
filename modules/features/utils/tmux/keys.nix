let
  # FIXME implement optional `note` argument.
  mkBindKeyCommand =
    {
      key,
      command,
      note ? null,
    }:
    let
      noteArgument = if note == null then "" else "-N ${builtins.toJSON note}";
    in
    "bind-key ${noteArgument} ${key} ${command}";
in
{
  flake.modules.homeManager.tmux = { lib, ... }: {
    programs.tmux = {
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";
      escapeTime = 0;

      extraConfig = lib.concatStringsSep "\n" (
        map mkBindKeyCommand [
          {
            key = "c";
            command = "new-window -c \"#{pane_current_path}\"";
            note = "Open new window";
          }

          {
            key = "|";
            command = "split-window -h -c \"#{pane_current_path}\"";
            note = "Split window horizontally";
          }

          {
            key = "-";
            command = ''split-window -v -c "#{pane_current_path}"'';
            note = "Split window vertically";
          }

          {
            key = "H";
            command = "swap-window -t -1\\; select-window -t -1";
            note = "Move window to the left";
          }

          {
            key = "L";
            command = "swap-window -t +1\\; select-window -t +1";
            note = "Move window to the right";
          }
        ]
      );
    };
  };
}
