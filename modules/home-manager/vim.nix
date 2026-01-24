{
  lib,
  params,
  pkgs,
  ...
}: {
  home.sessionVariables = lib.mkIf (params.editor == "vim") {
    EDITOR = "vim";
    MANPAGER = "vim -M +MANPAGER -";
  };
}
