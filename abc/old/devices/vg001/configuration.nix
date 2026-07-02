{
  params,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./impermanence.nix

    ../../modules/nixos/nix-index.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Workaround because console defaults to serial
  boot.kernelParams = ["console=tty"];
  # Initialize the display early to get a complete log
  boot.initrd.kernelModules = ["virtio_gpu"];

  networking.hostName = params.hostname;

  time.timeZone = params.timezone;

  # Internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  users.mutableUsers = false;

  # Define user account
  users.users.${params.username} = {
    isNormalUser = true;
    description = params.name;
    extraGroups = ["wheel"];
    shell = pkgs.${params.shell};
    # echo "PASSWORD" | mkpasswd -s
    hashedPasswordFile = "/persist/run/secrets/${params.username}-hashed-pwd";
    initialPassword = "CHANGEME!!!";
  };

  # echo "PASSWORD" | mkpasswd -s
  users.users.root.hashedPasswordFile = "/persist/run/secrets/root-hashed-pwd";
  users.users.root.initialPassword = "CHANGEME!!!";

  # List packages installed system-wide:
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  # Configure Filesystem Permissions
  systemd.tmpfiles.settings = {
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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = params.state-version; # Did you read the comment?
}
