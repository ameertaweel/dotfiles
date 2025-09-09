{
  persistDirBackup,
  persistDirNoBackup,
  ...
}: {inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  fileSystems.${persistDirBackup}.neededForBoot = true;
  fileSystems.${persistDirNoBackup}.neededForBoot = true;

  environment.persistence.${persistDirBackup} = {
    enable = true;
    hideMounts = true;
    directories = [
      # We need to be able to look at logs and coredumps even after reboot
      "/var/log"
      "/var/lib/systemd/coredump"
    ];
  };

  environment.persistence.${persistDirNoBackup} = {
    enable = true;
    hideMounts = true;
    directories = [
      # Persisting `/var/lib/nixos` is vital to the correct functioning of the
      # UID/GID allocation mechanism of NixOS.
      # If `/var/lib/nixos` is not persisted, UIDs/GIDs are allocated
      # sequentially, and so can shift around across boots if new ones are added
      # to the configuration. It can happen that after a reboot, a file is now
      # randomly owned by a different user.
      "/var/lib/nixos"

      # Persistent SystemD Timers
      "/var/lib/systemd/timers"
    ];
    files = [
      # SystemD Local Machine ID
      "/etc/machine-id"
    ];
  };

  # Never show the sudo lecture
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
