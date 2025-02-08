{...}: {
  programs.ssh.enable = true;
  home.file.".ssh/known_hosts".source = ../../dotfiles/ssh/known_hosts;
}
