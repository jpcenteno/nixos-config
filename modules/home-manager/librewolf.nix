{ ... }:
{
  programs.librewolf = {
    enable = true;
  };

  # Taken from [1].
  # [1]:  https://github.com/ngkz/dotfiles/blob/941fcbc7f30dab2254e744e187476648423ca922/home/workstation/librewolf/default.nix#L17
  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "text/xml" = "librewolf.desktop";
    "application/xhtml+xml" = "librewolf.desktop";
    "application/vnd.mozilla.xul+xml" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
  };
}
