{pkgs, ...}: {
  imports = [../fonts.nix];

  programs.mpv = {
    enable = true;
    scripts = [pkgs.mpvScripts.mpris];
    config = {
      sub-font = "Dubai";
    };
  };
}
