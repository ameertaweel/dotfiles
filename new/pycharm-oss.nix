{config, ...}: {
  nixpkgs.overlays = [ (final: prev: {
	jetbrains = prev.jetbrains // {
	mkPyCharmOSSWithPlugins = final.jetbrains.mkIDEWithPlugins "pycharm-oss";
};
  }) ];

  # Example usage of this function:
  # (pkgs.jetbrains.mkJetbrainsIDE "idea" ["com.intellij.plugins.watcher"])
}
