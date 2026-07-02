{
  description = "My VG001 (VPS 1000 ARM G11) Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Disko (Declarative Disk Partitioning and Formatting)
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Nix Index Database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    params = {
      hostname = "vg001";
      username = "labmem001";
      name = "Ameer Taweel";
      email = "ameertaweel2002@gmail.com";
      system = "aarch64-linux";
      state-version = "24.11";
      editor = "vim";
      timezone = "Europe/Vienna";
      shell = "bash";
      # Find using `cat /etc/machine-id`
      machine-id = "5a8f16c0f2344ec4bf4ed1ed18d3830d";
    };
  in {
    # NixOS configuration entrypoint
    # Available through `nixos-rebuild --flake .#your-hostname`
    nixosConfigurations.${params.hostname} = inputs.nixpkgs.lib.nixosSystem {
      inherit (params) system;
      specialArgs = {inherit inputs outputs params;};
      modules = [
        ./configuration.nix
      ];
    };
  };
}
