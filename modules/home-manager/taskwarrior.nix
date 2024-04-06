{ ... }:
{
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-16";
    # Set INBOX as the default project to capture new tasks.
    config.default.project = "INBOX";
  };

  programs.bash.shellAliases.t = "task";
}
