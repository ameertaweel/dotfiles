{ lib, config, ... }: {
  options = {
    nixosModules = lib.mkOption (
      let
        inherit (lib.types) lazyAttrsOf either deferredModule;
        type = lazyAttrsOf (either deferredModule type);
      in
      {
        inherit type;
      }
    );
  };

  config = {
    nixosModules = {
      nix-index = ./nix-index.nix;
    };
  };
}
