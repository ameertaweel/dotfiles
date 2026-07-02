{pkgs, ...}: {
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override {
      withNerdIcons = true;
    };
  };
}
