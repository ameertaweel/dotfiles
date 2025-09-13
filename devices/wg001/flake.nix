{
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NixOS WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

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
      hostname = "wg001";
      username = "nixos";
      system = "x86_64-linux";
      state-version = "24.11";
    };
  in {
    # NixOS configuration entrypoint
    # Available through `nixos-rebuild --flake .#your-hostname`
    nixosConfigurations.${params.hostname} = inputs.nixpkgs.lib.nixosSystem {
      inherit (params) system;
      specialArgs = {inherit inputs outputs params;};
      modules = [
        ./wsl.nix
        ./configuration.nix
      ];
    };
  };
}
