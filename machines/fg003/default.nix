{ ... }: {
  machines.fg003 = { ... }: {
    hostPlatform = "x86_64-linux";

    nixpkgs.source = (import ../../nix/tamal { }).nixpkgs;

    nix-index = {
      enable = true;
      source = (import ../../nix/tamal { }).nix-index-database;
    };

    nixosModules = [
      {
        system.stateVersion = "25.11";
      }
      ./configuration.nix
    ];
  };
}
