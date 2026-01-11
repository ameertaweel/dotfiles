{ config, ... }: let
in {
  imports = [
    (import (import ./npins).nix-maid).nixosModules.default
  ];

  users.users.labmem001.maid = {
  };
}
