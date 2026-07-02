{params, ...}: {
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  users.users.${params.username}.extraGroups = ["libvirtd"];
}
