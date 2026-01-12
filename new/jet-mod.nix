{ideName, ideDisplayName, unfree ? false}:

{ lib, config, pkgs, ... }: let
  userSubmodule =
    { config, ... }: let
      cnf = config.custom.programs.jetbrains.${ideName};
    in {
      options = {
	custom.programs.jetbrains.${ideName} = {
	  enable = lib.mkOption {
	    description = ''
	      Enable ${ideDisplayName} for the user.
	    '';
	    type = lib.types.bool;
	    default = false;
	  };

	  plugins = lib.mkOption {
	    description = ''
	      ${ideDisplayName} plugins to install.
	    '';
	    type = lib.types.listOf lib.types.string;
	    default = ["IdeaVIM"];
	  };
	};
      };

      config = lib.mkIf (cnf.enable) {
	custom.nixMaidUser = true;

	packages = [
	  (pkgs.custom.jetbrains.mkIDEWithPlugins ideName cnf.plugins)
	];

      };
    };

  ideUsers = builtins.attrNames (
    lib.filterAttrs (user: userConfig: userConfig.custom.programs.jetbrains.${ideName}.enable) config.users.users
  );
  ideUsersCount = builtins.length ideUsers;
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
    };
  };

  config = {
    custom.nixMaid.enable = lib.mkIf (ideUsersCount > 0) true;
	custom.nixpkgs.allowUnfreePredicates = lib.mkIf (unfree) [
	  (
	    pkg:
	    builtins.elem (lib.getName pkg) [
	      ideName
	      "${ideName}-with-plugins"
	    ]
	  )
	];
  };
}
