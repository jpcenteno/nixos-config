{ ... }:
{
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-16";
  };

  programs.bash.shellAliases.t = "task";
}
