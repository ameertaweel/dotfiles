{
  params,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/nixos/nix.nix
    ../../modules/nixos/virtualization/docker.nix
  ];

  users.users.${params.username} = {
    packages = [
      pkgs.git
      pkgs.ripgrep
      pkgs.fd
      pkgs.tree
      pkgs.lazydocker
    ];
    shell = pkgs.bash;
  };

  programs.direnv.enable = true;

  programs.bash.interactiveShellInit = ''
    source "${pkgs.wezterm}/etc/profile.d/wezterm.sh"
  '';

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  services.redis.servers."".enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = params.state-version; # Did you read the comment?
}
