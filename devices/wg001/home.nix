{
  params,
  ...
}: {
  # TODO: Import From `../../modules/home-manager/core.nix`

  # Enable home-manager
  programs.home-manager.enable = true;

  home = {
    inherit (params) username;
    homeDirectory = "/home/${params.username}";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = params.state-version;

  imports = [
    ../../modules/home-manager/vim
  ];
}
