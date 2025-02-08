{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jpcenteno-home.desktop.apps.zathura;
  desktopEntry = "org.pwmt.zathura.desktop";
in {
  options.jpcenteno-home.desktop.apps.zathura = {
    enable = lib.mkEnableOption "Zathura";
  };

  config = lib.mkIf cfg.enable {
    warnings = builtins.concatLists [
      (lib.optional (! config.xdg.mimeApps.enable) "Zathura: Set `xdg.mimeAps.enable = true` to use Zathura as the default document opener.")
    ];

    home.packages = [pkgs.zathura];
    xdg.configFile."zathura/zathurarc".source = ../../../../dotfiles/zathura/zathurarc;

    # NOTE 2024-10-15: Where to find desktop entries and their MIME types:
    #
    # - Home-manager will place Zathura's `.desktop` entries at
    #   `/etc/profiles/per-user/<user>/share/applications/`.
    # - Use `ls <dir> | grep -i zathura` to find Zathura's desktop entries.
    # - Look for the `MimeType` entry.
    #
    # NOTE 2024-10-15: Check the MIME types before setting the app as default:
    # The `MimeType` entry lists all the MIME types that the application can
    # open, for example, `application/x-zip` files. This does not mean that we
    # want Zathura to be the default opener. Remember to remove those from the
    # attribute set.
    xdg.mimeApps = {
      defaultApplications = {
        "application/x-cbr" = ["org.pwmt.zathura-cb.desktop"];
        "application/x-cbz" = ["org.pwmt.zathura-cb.desktop"];
        "application/x-cb7" = ["org.pwmt.zathura-cb.desktop"];
        "application/x-cbt" = ["org.pwmt.zathura-cb.desktop"];
        "application/vnd.comicbook-rar" = ["org.pwmt.zathura-cb.desktop"];
        "application/vnd.comicbook+zip" = ["org.pwmt.zathura-cb.desktop"];

        "image/vnd.djvu" = ["org.pwmt.zathura-djvu.desktop"];
        "image/vnd.djvu+multipage" = ["org.pwmt.zathura-djvu.desktop"];

        "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
        "application/oxps" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
        "application/epub+zip" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
        "application/x-fictionbook" = ["org.pwmt.zathura-pdf-mupdf.desktop"];

        "application/postscript" = ["org.pwmt.zathura-ps.desktop"];
        "application/eps" = ["org.pwmt.zathura-ps.desktop"];
        "application/x-eps" = ["org.pwmt.zathura-ps.desktop"];
        "image/eps" = ["org.pwmt.zathura-ps.desktop"];
        "image/x-eps" = ["org.pwmt.zathura-ps.desktop"];
      };
    };
  };
}
