{...}: let
  intelBusId = "PCI:0:2:0";
  nvidiaBusId = "PCI:1:0:0";
in {
  specialisation.nvidia-enabled.configuration = {
    system.nixos.tags = ["nvidia-enabled"];

    # Nvidia drivers are unfree
    imports = [../../modules/nixpkgs-unfree.nix];

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      open = false;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # Bus ID of the Intel GPU
        # Find it using lspci, either under 3D or VGA
        inherit intelBusId;

        # Bus ID of the Nvidia GPU
        # Find it using lspci, either under 3D or VGA
        inherit nvidiaBusId;
      };

      # Modesetting is needed for most Wayland compositors
      modesetting.enable = true;
    };
  };
}
