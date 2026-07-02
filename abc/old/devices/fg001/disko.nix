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
      ssd = {
        type = "disk";
        device = "/dev/sdb";
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
              end = "-32G";
              content = {
                type = "zfs";
                pool = "zssd";
              };
            };
            swap = {
              size = "100%";
              type = "8200"; # Linux Swap
              content = {
                type = "swap";
                randomEncryption = true;
                # Can't Resume From Hiberation Using Randomly-Encrypted Swap
                # https://github.com/nix-community/disko/issues/448
                resumeDevice = false;
              };
            };
          };
        };
      };
      hdd = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            main = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zhdd";
              };
            };
          };
        };
      };
    };
    zpool = {
      zssd = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          canmount = "off";
          mountpoint = "none";
          "com.sun:auto-snapshot" = "false";
        };

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
              zfs snapshot zssd/enc/root@blank
            '';
          };
          "enc/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "enc/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist-ssd";
          };
          "enc/hdd-key" = {
            type = "zfs_fs";
            mountpoint = "/hdd-key";
            postMountHook = ''
              # Find where the dataset was mounted
              mount_dir=$(zfs list | grep zssd/enc/hdd-key | tr -s " " | cut -d " " -f 5)
              # Copy the HDD key there
              cp /tmp/hdd.key "$mount_dir"
            '';
          };
        };
      };
      zhdd = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          canmount = "off";
          mountpoint = "none";
          "com.sun:auto-snapshot" = "false";
        };
        datasets = {
          enc = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/hdd.key";
            };
            preCreateHook = ''
              rm -f /tmp/hdd.key
              cat /dev/urandom | tr -dc "a-zA-Z0-9[:punct:]" | fold -w 32 | head -n 1 > /tmp/hdd.key
            '';
            postCreateHook = ''
              zfs set keylocation="file:///hdd-key/hdd.key" "zhdd/enc"
            '';
          };
          "enc/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist-hdd";
          };
        };
      };
    };
  };

  # Required by ZFS
  networking.hostId = builtins.substring 0 8 params.machine-id;

  # Rollback to Empty Root On Boot
  boot.initrd.postResumeCommands = lib.mkAfter ''
    zfs rollback -r zssd/enc/root@blank

    zfs mount zssd/enc/hdd-key
    zfs load-key zhdd/enc
    zfs unmount /hdd-key
  '';

  # ZFS pool imports don't work otherwise
  boot.zfs.forceImportAll = true;

  # ZFS hibernation can cause data loss
  boot.zfs.allowHibernation = false;

  # Maintain Pool Health
  services.zfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  # Configure Filesystem Permissions
  systemd.tmpfiles.settings = {
    "persist" = {
      "/persist-ssd" = {
        d = {
          group = "root";
          mode = "1777";
          user = "root";
        };
      };
      "/persist-hdd" = {
        d = {
          group = "root";
          mode = "1777";
          user = "root";
        };
      };
    };
    "hdd-key" = {
      "/hdd-key" = {
        d = {
          group = "root";
          mode = "1700";
          user = "root";
        };
      };
      "/hdd-key/hdd.key" = {
        f = {
          group = "root";
          mode = "0400";
          user = "root";
        };
        h = {
          argument = "+i";
        };
      };
    };
  };
}
