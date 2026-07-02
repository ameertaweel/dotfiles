{pkgs, ...}: {
  imports = [
    ./borgmatic.nix

    ../../modules/home-manager/anydesk.nix
    ../../modules/home-manager/browsers/brave.nix
    ../../modules/home-manager/browsers/qutebrowser.nix
    ../../modules/home-manager/browsers/tor.nix
    ../../modules/home-manager/core.nix
    ../../modules/home-manager/documents/zathura.nix
    ../../modules/home-manager/emacs
    ../../modules/home-manager/fonts.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/gnome.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/wezterm
    ../../modules/home-manager/neovim
    ../../modules/home-manager/nnn.nix
    ../../modules/home-manager/rar.nix
    ../../modules/home-manager/shell.nix
    ../../modules/home-manager/tmux
    ../../modules/home-manager/video-players/mpv.nix
    ../../modules/home-manager/vim
    ../../modules/home-manager/xdg.nix
  ];

  home.packages = with pkgs; [
    gimp
    libreoffice
    qbittorrent
    tdesktop
    element-desktop
  ];

}
