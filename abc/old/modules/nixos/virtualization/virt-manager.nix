{pkgs, ...}: {
  imports = [./libvirtd.nix];

  environment.systemPackages = [pkgs.virt-manager];

  # virt-manager requires dconf to remember settings
  programs.dconf.enable = true;
}
