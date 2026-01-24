{nix-wrapper-modules, pkgs}:

nix-wrapper-modules.wrappers.btop.wrap ({ ... }: {
  inherit pkgs;

  settings = {
    vim_keys = true;
    color_theme = "ayu";
  };
})
