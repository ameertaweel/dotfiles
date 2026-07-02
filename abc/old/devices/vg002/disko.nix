{
  hostId,
  diskEncryptionKeyFile,
  persistDirBackup,
  persistDirNoBackup,
  ...
}: {
  lib,
  inputs,
  ...
}: {
  imports = [inputs.disko.nixosModules.disko];

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
          # Explanation for `acltype=posixacl` and `xattr=sa`:
          # https://www.reddit.com/r/zfs/comments/dltik7/comment/f4uk9xk
          # https://web.archive.org/web/20231218153741/https://old.reddit.com/r/zfs/comments/dltik7/whats_the_purpose_of_the_acltype_property/f4uk9xk/
          acltype = "posixacl";
          xattr = "sa";
          # Disable access time updates on files, improving performance by
          # reducing write operations on read access.
          atime = "off";
          compression = "zstd";
          canmount = "off";
          mountpoint = "none";
          "com.sun:auto-snapshot" = "false";
        };
        # Set alignment shift to 4KiB
        # https://www.high-availability.com/docs/ZFS-Tuning-Guide/#alignment-shift-ashiftn
        options.ashift = "12";

        datasets = {
          enc = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file://${diskEncryptionKeyFile}";
            };
            # Override `keylocation` after creation to require manual passphrase
            # entry at boot.
            postCreateHook = ''
              zfs set keylocation="prompt" "zroot/$name";
            '';
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
          "enc/persist/backup" = {
            type = "zfs_fs";
            mountpoint = persistDirBackup;
          };
          "enc/persist/nobackup" = {
            type = "zfs_fs";
            mountpoint = persistDirNoBackup;
          };
        };
      };
    };
  };

  # Required by ZFS
  # Ensure that ZFS pool isn't imported accidentally on a wrong machine
  # Try to make this ID unique among your machines
  # Can be generated via `head -c4 /dev/urandom | od -A none -t x4`
  networking.hostId = builtins.substring 0 8 hostId;

  # Rollback to empty root on boot
  boot.initrd.postResumeCommands = lib.mkAfter ''
    zfs rollback -r zroot/enc/root@blank
  '';

  # Importing the ZFS pool fails without this
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  # ZFS hibernation can cause data loss
  boot.zfs.allowHibernation = false;

  # Maintain Pool Health
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
}
