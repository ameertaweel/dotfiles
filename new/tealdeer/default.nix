{pkgs, wrappers, ...}: wrappers.lib.wrapPackage {
  inherit pkgs;
  package = pkgs.tealdeer;
  flags = {
    "--config-path" = "${./config.toml}";
  };
}
