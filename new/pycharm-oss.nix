{config, lib, ...}: let
  defaultPlugins = ["IdeaVIM"];
in {
  nixpkgs.overlays = [
    (final: prev: let
      mkIDE = final.custom.jetbrains.mkIDEWithPlugins;
      # android-studio = final.android-studio.overrideAttrs {
	# pname = "android-studio";
	# name = "android-studio-${final.android-studio.version}";
      # };
    in {
      custom = (prev.custom or {}) // {
	jetbrains = (prev.custom.jetbrains or {}) // {
	  idea-oss = mkIDE "idea-oss" defaultPlugins;
	  idea = mkIDE "idea" defaultPlugins;
	  pycharm-oss = mkIDE "pycharm-oss" defaultPlugins;
	  pycharm = mkIDE "pycharm" defaultPlugins;
	};
	# android-studio = mkIDE android-studio defaultPlugins;
      };
    })
  ];

  custom.nixpkgs.allowUnfreePredicates = [
    (
      pkg:
      builtins.elem (lib.getName pkg) [
	"idea"
	"idea-with-plugins"
	"pycharm"
	"pycharm-with-plugins"
	# "android-studio"
	# "android-studio-with-plugins"
      ]
    )
  ];
}
