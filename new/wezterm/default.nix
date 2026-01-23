{nix-wrapper-modules, pkgs}:

nix-wrapper-modules.wrappedModules.wezterm.wrap ({ ... }: {
  inherit pkgs;

  "wezterm.lua".path = ./wezterm.lua;

  # Colon-separated list of font dirs
  env.WEZTERM_CUSTOM_FONT_DIRS = builtins.concatStringsSep ":" [
    "${pkgs.nerd-fonts.hack}"
  ];
})
