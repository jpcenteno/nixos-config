# WinUnisoft
# ==========
#
# Installer: pending
# ------------------
#
# I can't push a module that installs this program to a public repositorry
# because it is propietory software.
#
# Also
# - I haven't automated the installation of Bottles with a NixOS / Home-Manager
#   module.
# - I don't know how to automate the setup of a bottle with Nix.
{
  flake.modules.homeManager.winunisoft = { config, ... }: {
    programs.niri.settings.window-rules = [
      {
        matches = [
          {
            app-id = "^steam_proton$";
            title = "WinUnisoft";
          }
        ];
        # Prevent WinUnisoft windows from floating around.
        open-floating = false;
      }
    ];
  };
}
