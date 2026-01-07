{ pkgs, ... }:
let
  inherit (import ./npins) nix-index-database;
  packages = import nix-index-database { inherit pkgs; };
in
{
  programs.nix-index.enable = true;
  programs.nix-index.package = packages.nix-index-with-db;
}
