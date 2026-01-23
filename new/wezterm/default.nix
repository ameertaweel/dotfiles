{nix-wrapper-modules, pkgs}:

nix-wrapper-modules.wrappedModules.wezterm.wrap ({ ... }: {
  inherit pkgs;

  "wezterm.lua".path = ./wezterm.lua;
})
