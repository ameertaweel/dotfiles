{
  lib,
  pkgs,
  params,
  ...
}: let
  modules = {
    hardware = import ./hardware.nix {
      inherit (params) system hostId diskEncryptionKeyFile persistDirBackup persistDirNoBackup;
    };
    impermanence = import ./impermanence.nix {
      inherit (params) persistDirBackup persistDirNoBackup;
    };
    users = import ./users.nix {
      inherit (params) username sshKey;
      hashedPassword = params.userHashedPassword;
    };
    ssh = import ./ssh.nix {
      persistDir = params.persistDirNoBackup;
    };
    sshInitrd = import ./ssh-initrd.nix {
      enable = !params.isBeforeInstall;
      sshPort = params.initrdSSHPort;
      authorizedKey = params.sshKey;
      persistDir = params.persistDirNoBackup;
    };
  };
in {
  imports = [
    modules.hardware
    modules.impermanence
    modules.users
    modules.ssh
    modules.sshInitrd
  ];

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  system.stateVersion = params.state-version;
}
