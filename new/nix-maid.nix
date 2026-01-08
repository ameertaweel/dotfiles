{ ... }:
{
  imports = [
    (import (import ./npins).nix-maid).nixosModules.default
  ];
}
