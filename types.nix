{ lib, ... }: {
  options = {
    types = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.optionType;
    };
  };
}
