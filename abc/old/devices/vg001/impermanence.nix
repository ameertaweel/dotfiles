{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      # We need to be able to look at coredumps even if one causes reboot
      "/var/lib/systemd/coredump"
      # Persistent SystemD Timers
      "/var/lib/systemd/timers"
      # Stateful Secrets
      "/run/secrets"
      # Tailscale State
      "/var/lib/tailscale"
      # Docker State
      "/var/lib/docker"
    ];
    files = [
      "/etc/machine-id"
    ];

    users.labmem001 = {
      directories = [
        "dotfiles"
        "workspace"
      ];
      files = [];
    };
  };

  # Never show the sudo lecture
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
