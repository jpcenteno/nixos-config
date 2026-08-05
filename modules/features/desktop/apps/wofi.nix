{
  flake.modules.homeManager.wofi = {
    programs.wofi = {
      enable = true;
      settings = {
        allow_images = true;
        image_size = 24;
        insensitive = true;
        allow_markup = true;
        dynamic_lines = true;
      };
    };
  };
}
