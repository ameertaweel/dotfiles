let
  sources = import ./nix/tamal { };

  pkgs = import sources.nixpkgs { };

  modules = [
    ./types.nix
    ./nixos-modules.nix
    ./machines
  ];
in
(pkgs.lib.evalModules { inherit modules; })
