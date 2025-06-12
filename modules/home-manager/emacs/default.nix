{...}: {
  programs.emacs.enable = true;

  home.file.doomEmacsConfig = {
    target = ".doom.d";
    source = ./doom;
    recursive = true;
  };
}
