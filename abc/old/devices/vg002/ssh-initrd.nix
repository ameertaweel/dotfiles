{
  enable,
  sshPort,
  authorizedKey,
  persistDir ? null,
  ...
}: let
  hostKeysDir = "/etc/ssh/host_keys_initrd";

  hostKeyRSA = "${hostKeysDir}/ssh_host_rsa_key_initrd";
  hostKeyED25519 = "${hostKeysDir}/ssh_host_ed25519_key_initrd";
in
  {
    lib,
    pkgs,
    ...
  }: let
    initrdShell = pkgs.writeShellScriptBin "initrd_shell" ''
      zpool import -a
      zfs load-key -a && killall zfs
    '';
  in {
    # Setup Host Keys
    services.openssh.hostKeys = [
      {
        bits = 4096;
        path = hostKeyRSA;
        type = "rsa";
      }
      {
        path = hostKeyED25519;
        type = "ed25519";
      }
    ];

    # Based On:
    # https://wiki.nixos.org/wiki/ZFS#Unlock_encrypted_ZFS_via_SSH_on_boot
    boot = lib.mkIf enable {
      initrd.network = {
        # This will use `udhcp` to get an ip address.
        # Make sure you have added the kernel module for your network driver to
        # `boot.initrd.availableKernelModules`, so your initrd can load it.
        # Static IP addresses might be configured using the `ip` argument in
        # kernel command line:
        # https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
        enable = true;
        ssh = {
          enable = true;
          # To prevent SSH clients from freaking out because a different host
          # key is used, a different port for SSH is useful (assuming the same
          # host has also a regular `sshd` running).
          port = sshPort;
          # `hostKeys` paths must be unquoted strings, otherwise you'll run into
          # issues with `boot.initrd.secrets`.
          # The keys are copied to initrd from the path specified.
          # Multiple keys can be set.
          hostKeys = [hostKeyRSA hostKeyED25519];
          # Public SSH key used for login.
          authorizedKeys = [authorizedKey];
          shell = "${initrdShell}/bin/initrd_shell";
        };
      };
    };

    # Impermanence Integration
    environment.persistence = lib.mkIf (persistDir != null) {
      ${persistDir}.directories = [hostKeysDir];
    };
  }
