{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
  };

  # Taken from [1].
  # [1]:  https://github.com/ngkz/dotfiles/blob/941fcbc7f30dab2254e744e187476648423ca922/home/workstation/librewolf/default.nix#L17
  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave.desktop";
    "text/xml" = "brave.desktop";
    "application/xhtml+xml" = "brave.desktop";
    "application/vnd.mozilla.xul+xml" = "brave.desktop";
    "x-scheme-handler/http" = "brave.desktop";
    "x-scheme-handler/https" = "brave.desktop";
  };
}
