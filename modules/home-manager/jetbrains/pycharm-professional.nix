{pkgs, ...}: {
  imports = [
    ../../nixpkgs-unfree.nix # `pycharm-professional` is unfree
    ./ideavim
  ];

  home.packages = [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.pycharm-professional [
      "ideavim"
    ])
  ];
}
