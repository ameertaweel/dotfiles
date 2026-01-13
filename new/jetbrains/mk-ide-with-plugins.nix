{ config, ... }:
let
  lib = config.custom.inputs.nix-jetbrains-plugins.lib;
  mkIDE = lib.buildIdeWithPlugins;
in
{
  # Example usage of this function:
  # (pkgs.custom.jetbrains.mkIDEWithPlugins "idea" ["com.intellij.plugins.watcher"])

  nixpkgs.overlays = [
    (final: prev: {
      custom = (prev.custom or { }) // {
        jetbrains = (prev.custom.jetbrains or { }) // {
          mkIDEWithPlugins = mkIDE final;
        };
      };
    })
  ];
}
