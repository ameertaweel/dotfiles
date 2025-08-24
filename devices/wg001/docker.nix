{config, ...}: {
  virtualisation.docker.enable = true;
  users.users.${config.wsl.defaultUser}.extraGroups = ["docker"];
}
