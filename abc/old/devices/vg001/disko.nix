{
  inputs,
  lib,
  params,
  ...
}: {
  imports = [
    # Disko NixOS Module
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00"; # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };
            main = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
          compression = "zstd";
          canmount = "off";
          mountpoint = "none";
          "com.sun:auto-snapshot" = "false";
        };
        options.ashift = "12";

        datasets = {
          enc = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
          };
          "enc/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = ''
              zfs snapshot zroot/enc/root@blank
            '';
          };
          "enc/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "enc/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };

  # Required by ZFS
  networking.hostId = builtins.substring 0 8 params.machine-id;

  # Rollback to Empty Root On Boot
  boot.initrd.postResumeCommands = lib.mkAfter ''
    zfs rollback -r zroot/enc/root@blank
  '';

  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  # ZFS pool imports don't work otherwise
  boot.zfs.forceImportAll = true;

  # ZFS hibernation can cause data loss
  boot.zfs.allowHibernation = false;

  # Maintain Pool Health
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  # Configure Filesystem Permissions
  systemd.tmpfiles.settings = {
    "persist" = {
      "/persist" = {
        d = {
          group = "root";
          mode = "1777";
          user = "root";
        };
      };
    };
  };
}
