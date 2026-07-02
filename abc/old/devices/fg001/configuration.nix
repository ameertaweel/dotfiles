{...}: {
  imports = [
    ./hardware.nix
    ./impermanence.nix
    ./headless.nix
    ./nvidia.nix
    ./printing.nix

    ../../modules/nixos/core.nix
    ../../modules/nixos/virtualization/virt-manager.nix
    ../../modules/nixos/virtualization/docker.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/nix-index.nix
    ../../modules/nixos/adb.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # System-wide packages
  # environment.systemPackages = [ ];

  services.tailscale = {
    enable = true;
    authKeyFile = "/run/secrets/tailscale_key";
  };

  # mDNS Config
  services.resolved.enable = true;
  networking.networkmanager.connectionConfig."connection.mdns" = 2;
  services.avahi.enable = true;

  # echo "PASSWORD" | mkpasswd -s
  users.users.labmem001.hashedPasswordFile = "/persist-ssd/run/secrets/labmem001-hashed-pwd";
  users.users.root.hashedPasswordFile = "/persist-ssd/run/secrets/root-hashed-pwd";

  # Configure Filesystem Permissions
  systemd.tmpfiles.settings = {
    "archive" = {
      "/home/labmem001/archive/operating-systems/*" = {
        Z = {
          group = "users";
          mode = "0444";
          user = "labmem001";
        };
        h = {
          argument = "+i";
        };
      };
      "/home/labmem001/archive/papers/*" = {
        Z = {
          group = "users";
          mode = "0444";
          user = "labmem001";
        };
        h = {
          argument = "+i";
        };
      };
    };
    "secrets" = {
      "/run/secrets" = {
        Z = {
          group = "root";
          mode = "0751";
          user = "root";
        };
      };
      "/run/secrets/*" = {
        h = {
          argument = "+i";
        };
      };
    };
  };

  # Use ‘nixos-rebuild-ng’ in place of ‘nixos-rebuild’
  system.rebuild.enableNg = true;
}
