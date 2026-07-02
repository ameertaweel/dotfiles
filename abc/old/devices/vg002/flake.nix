{
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
    params = import ./params.nix;
  in {
    # NixOS configuration entrypoint
    # Available through `nixos-rebuild --flake .#your-hostname`
    # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
    nixosConfigurations.${params.hostname} = nixpkgs.lib.nixosSystem {
      inherit (params) system;
      specialArgs = {inherit inputs outputs params;};
      modules = [
        ./configuration.nix
      ];
    };

    lib = import ./lib.nix;
  };
}
