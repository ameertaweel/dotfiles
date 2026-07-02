{nix-wrapper-modules, ...}:

nix-wrapper-modules.wrappers.btop.apply ({ ... }: {
  settings = {
    vim_keys = true;
    color_theme = "ayu";
  };
})
