{pkgs, ...}: {
  imports = [../import-overlays.nix];

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Nerd Fonts
    nerd-fonts.fira-code
    nerd-fonts.hack
    xkcd-font
    kawkab-mono-font
    amiri
    redhat-official-fonts
    liberation_ttf
    font-noto-sans-arabic
    font-dubai
    font-cairo
    # corefonts
    # vistafonts
  ];
}
