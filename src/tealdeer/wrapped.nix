{ nix-wrapper-modules, ... }:

nix-wrapper-modules.wrappers.tealdeer.apply (
  { ... }: {
    settings = {
      search = {
        languages = [ "en" ];
      };

      updates = {
        auto_update = true;
        download_languages = [ "en" ];
      };
    };
  }
)
