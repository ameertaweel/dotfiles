{pkgs, ...}: {
  imports = [
    ../../modules/nixpkgs-unfree.nix
  ];

  # Enable CUPS Printing Service
  services.printing.enable = true;
  # Enable HP Proprietary Driver
  services.printing.drivers = [pkgs.hplipWithPlugin];
}
