{ ... }:
let desktopEntry = "org.pwmt.zathura.desktop";
in {
  programs.zathura.enable = true;

  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = [ desktopEntry ];
      "application/epub+zip" = [ desktopEntry ];
      "application/vnd.comicbook+zip" = [ desktopEntry ]; # .cbz
      "application/vnd.comicbook-rar" = [ desktopEntry ]; # .cbr
    };
  };
}
