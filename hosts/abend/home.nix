{ config, pkgs, ... }:

{

  imports = [
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/shell-extras.nix
    ../../modules/home-manager/ssh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "bipolarlisp";
  home.homeDirectory = "/home/bipolarlisp";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # FIXME. Added this to ensure that home-manager works.
    pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  # ╔══════════════════════════════════════════════════════════════════════════╗
  # ║ Session variables                                                        ║
  # ╠══════════════════════════════════════════════════════════════════════════╣
  # ║                                                                          ║
  # ║ Note that for Linux hosts a new session is required for changes to take  ║
  # ║ effect. This means that the user will have to log out, then log back     ║
  # ║ in to see the changes.                                                   ║
  # ║                                                                          ║
  # ╚══════════════════════════════════════════════════════════════════════════╝

  home.sessionVariables = {};

  # Populate `sessionVariables` with default values for the XDG base directory
  # environment variables.
  xdg.enable = true;

  # This makes bash inherit `home.sessionVariables`.
  programs.bash.enable = true;
}
