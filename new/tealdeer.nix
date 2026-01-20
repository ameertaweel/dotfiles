{nix-wrapper-modules, pkgs}:

nix-wrapper-modules.wrappedModules.tealdeer.wrap ({ ... }: {
  inherit pkgs;

  settings = {
    search = {
      languages = ["en"];
    };

    updates = {
      auto_update = true;
      download_languages = ["en"];
    };
  };
})
