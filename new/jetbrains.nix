{config, ...}: let
  sources = import ./npins;
  jetbrainsLib = (import sources.nix-jetbrains-plugins).lib.${config.nixpkgs.hostPlatform.system};
in {
  # Example usage of this function:
  # (pkgs.jetbrains.mkJetbrainsIDE "idea" ["com.intellij.plugins.watcher"])

  nixpkgs.overlays = [ (final: prev: {
	jetbrains = prev.jetbrains // {
		mkIDEWithPlugins = jetbrainsLib.buildIdeWithPlugins final.jetbrains;
};
  }) ];

}
