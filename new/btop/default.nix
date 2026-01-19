{pkgs, wrappers, ...}: wrappers.lib.wrapPackage {
  inherit pkgs;
  package = pkgs.btop;
  flags = {
    "--config" = "${./config.conf}";
  };
}
