{
  params,
  pkgs,
  ...
}: {
  # `teamviewer` is unfree
  imports = [../nixpkgs-unfree.nix];

  users.users.${params.username}.packages = [pkgs.teamviewer];

  # Enable TeamViewer Daemon
  services.teamviewer.enable = true;
}
