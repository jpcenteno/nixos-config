{
  flake.modules.homeManager = {
    desktop-notifications = { lib, pkgs, ... }: {
      services.mako = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        settings = {
          default-timeout = 8000; # (ms)
        };
      };
    };

    # Theming is applied on the condition that the user imports the `aesthetics`
    # module.
    #
    # NOTE: This relies heavily on the Stylix HM module for Mako [5] [6].
    #
    # [5]: https://nix-community.github.io/stylix/options/modules/mako.html#stylixtargetsmakofontsoverride
    # [6]: https://github.com/nix-community/stylix/blob/fb28acd59e2ac1984ec84fa496599d6b4bf3e690/modules/mako/hm.nix
    #
    # NOTE 2026-09-27:
    #
    # I'm testing this approach of moving the theming configuration to the
    # aesthetics module within the same file. So far I think that this helps me
    # keep things neatly organized while decoupling the `desktop-notifications`
    # module from an eventual dependency on the `aesthetics` module.
    aesthetics = { config, lib, ... }: {
      # No need for the `isLinux` predicate here thanks to lazy evaluation.
      services.mako.settings = {
        # TODO 2026-09-27: Unify border-radius across applications.
        border-radius = 8;

        outer-margin = "16";

        # The accepted format as per `man 5 mako` is a _Pango font description_ [2].
        #
        # NOTE 2026-09-27:
        #
        # The Stylix module for Mako uses the sans-serif font
        # [3], but I prefer it to use my monospace one both for personal taste
        # and consistency with waybar, which already uses monospace by default
        # [4].
        #
        # There are two ways for setting this: Passing a font override mapping
        # the sans-serif font to the monospace one (hacky), or redefining
        # `services.mako.settings.font`. That's why I had to put the `mkForce`
        # here. The Stylix HM module for Mako already provides a definition for
        # that value.
        #
        # The `popups` font size is the same value used at the Mako module [3].
        #
        # [2]: https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html#description
        # [3]: https://github.com/nix-community/stylix/blob/fb28acd59e2ac1984ec84fa496599d6b4bf3e690/modules/mako/hm.nix#L6
        # [4]: https://github.com/nix-community/stylix/blob/fb28acd59e2ac1984ec84fa496599d6b4bf3e690/modules/waybar/hm.nix#L17
        font =
          let
            fontFamily = config.stylix.fonts.monospace.name;
            fontSizePt = config.stylix.fonts.sizes.popups;
          in
          lib.mkForce "${fontFamily} ${toString fontSizePt}";
      };
    };
  };
}
