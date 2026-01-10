# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

let
  sources = import ./npins;

  nixpkgsChannel = sources.nixos-unstable;
  nixpkgsHostPlatform = "x86_64-linux";
  stateVersion = "25.11";

  fullName = "Ameer Taweel";

  configuration =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      imports = [
        # Include the results of the hardware scan.
        # ./hardware-configuration.nix
        ./modules.nix
      	./hardware-configuration.nix
      ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

      # networking.hostName = "nixos"; # Define your hostname.

      # Set your time zone.
      # time.timeZone = "Europe/Amsterdam";

      # Select internationalisation properties.
      # i18n.defaultLocale = "en_US.UTF-8";
      # console = {
      #   font = "Lat2-Terminus16";
      #   keyMap = "us";
      #   useXkbConfig = true; # use xkb.options in tty.
      # };

      # Enable the X11 windowing system.
      services.xserver.enable = false;

      # Enable the GNOME Desktop Environment.
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      hardware.bluetooth.enable = true;

      # Configure keymap in X11
      # services.xserver.xkb.layout = "us";
      # services.xserver.xkb.options = "eurosign:e,caps:escape";

      # Enable CUPS to print documents.
      # services.printing.enable = true;

      documentation.nixos.includeAllModules = true;

      # Install firefox.
      programs.firefox.enable = false;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.labmem001 = {
        isNormalUser = true;
        description = fullName;
    	extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
        packages = [
          pkgs.brave
          pkgs.vlc
          (pkgs.jetbrains.mkPyCharmOSSWithPlugins ["IdeaVIM"])
        ];
        password = "labmem001";
        custom = {
          adbUser = true;
          dockerUser = true;
          podmanUser = true;
          virtualBoxUser = false;

          anydesk.enable = true;
        };
      };

      custom.nix-index.enable = true;
      custom.podman.enable = true;
      custom.docker.enable = true;
      custom.guix.enable = true;

      custom.virtualBox.enable = false;
      custom.virtualBox.headless = false;

      custom.windowsDualBootFix.enable = true;

      # programs.firefox.enable = true;

      # List packages installed in system profile.
      # You can use https://search.nixos.org/ to find more packages (and options).
      environment.systemPackages = [
        pkgs.tree
        pkgs.vim
        pkgs.wget
        pkgs.git
        pkgs.file
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Copy the NixOS configuration file and link it from the resulting system
      # (/run/current-system/configuration.nix). This is useful in case you
      # accidentally delete configuration.nix.
      # system.copySystemConfiguration = true;

      custom.nixpkgs.channel = nixpkgsChannel;
      nixpkgs.hostPlatform = nixpkgsHostPlatform;

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
      system.stateVersion = stateVersion; # Did you read the comment?
    };

  nixos = import (nixpkgsChannel + "/nixos") {
    inherit configuration;
    system = null;
  };
in nixos
