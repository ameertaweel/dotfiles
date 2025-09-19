{
  lib,
  params,
  ...
}: let
  ifDefault = lib.mkIf (builtins.elem params.pdf-reader ["zathura"]);
in {
  # Zathura
  # Highly customizable and functional document viewer focused on keyboard
  # interaction.
  programs.zathura = {
    enable = true;
    options = {
      # Enable dark mode by default
      recolor = true;
      # Ability to paste selection
      selection-clipboard = "clipboard";
    };
  };

  xdg.mime.enable = ifDefault true;
  xdg.mimeApps.enable = ifDefault true;
  xdg.mimeApps.defaultApplications = ifDefault {
    "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
  };
}
