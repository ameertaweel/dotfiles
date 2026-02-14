{nix-wrapper-modules, pkgs}:

(nix-wrapper-modules.lib.evalModule ({ config, wlib, lib, ... }: let
  types = lib.types;
in {
  # You can only grab the final package if you supply pkgs!
  # But if you were making it for someone else, you would want them to do that!

  config.pkgs = pkgs;

  # include wlib.modules.makeWrapper and wlib.modules.symlinkScript
  imports = [ wlib.modules.default ];
  # The core options are focused on building a wrapper derivation.
  # different wrapper options may be implemented on top, for things like bubblewrap or other tools.
  # `wlib.modules.default` gives you a great module-based pkgs.makeWrapper to use.

  options = {
    enable = lib.mkEnableOption "management of XDG base directories";

    cacheHome = lib.mkOption {
      type = types.path;
      defaultText = "~/.cache";
      apply = toString;
      description = ''
        Absolute path to directory holding application caches.

        Sets `XDG_CACHE_HOME` for the user if `xdg.enable` is set `true`.
      '';
    };

    configHome = lib.mkOption {
      type = types.path;
      defaultText = "~/.config";
      apply = toString;
      description = ''
        Absolute path to directory holding application configurations.

        Sets `XDG_CONFIG_HOME` for the user if `xdg.enable` is set `true`.
      '';
    };

    dataHome = lib.mkOption {
      type = types.path;
      defaultText = "~/.local/share";
      apply = toString;
      description = ''
        Absolute path to directory holding application data.

        Sets `XDG_DATA_HOME` for the user if `xdg.enable` is set `true`.
      '';
    };

    stateHome = lib.mkOption {
      type = types.path;
      defaultText = "~/.local/state";
      apply = toString;
      description = ''
        Absolute path to directory holding application states.

        Sets `XDG_STATE_HOME` for the user if `xdg.enable` is set `true`.
      '';
    };
  };

  options.userDirs = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to manage {file}`$XDG_CONFIG_HOME/user-dirs.dirs`.

        The generated file is read-only.
      '';
    };

    package = lib.mkPackageOption pkgs "xdg-user-dirs" { nullable = true; };

    # Well-known directory list from
    # https://gitlab.freedesktop.org/xdg/xdg-user-dirs/blob/master/man/user-dirs.dirs.xml

    desktop = lib.mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = "$HOME/Desktop";
      description = "The Desktop directory.";
    };

    documents = lib.mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = "$HOME/Documents";
      description = "The Documents directory.";
    };

    download = lib.mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = "$HOME/Downloads";
      description = "The Downloads directory.";
    };

    music = lib.mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = "$HOME/Music";
      description = "The Music directory.";
    };

    pictures = lib.mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = "$HOME/Pictures";
      description = "The Pictures directory.";
    };

    publicShare = lib.mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = "$HOME/Public";
      description = "The Public share directory.";
    };

    templates = lib.mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = "$HOME/Templates";
      description = "The Templates directory.";
    };

    videos = lib.mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = "$HOME/Videos";
      description = "The Videos directory.";
    };

    extraConfig = lib.mkOption {
      type = with types; attrsOf (coercedTo path toString str);
      default = { };
      defaultText = lib.literalExpression "{ }";
      example = lib.literalExpression ''
        {
          MISC = "''${config.home.homeDirectory}/Misc";
        }
      '';
      description = ''
        Other user directories.

        The key ‘MISC’ corresponds to the user-dirs entry ‘XDG_MISC_DIR’.
      '';
    };

    createDirectories = lib.mkEnableOption "automatic creation of the XDG user directories";

    setSessionVariables = lib.mkOption {
      type = with types; bool;
      default = true;
      description = ''
        Whether to set the XDG user dir environment variables, like
        `XDG_DESKTOP_DIR`.

        ::: {.note}
        The recommended way to get these values is via the `xdg-user-dir`
        command or by processing `$XDG_CONFIG_HOME/user-dirs.dirs` directly in
        your application.
        :::
      '';
    };
  };

  config = let
    baseDirs = {
      XDG_CACHE_HOME = config.cacheHome;
      XDG_CONFIG_HOME = config.configHome;
      XDG_DATA_HOME = config.dataHome;
      XDG_STATE_HOME = config.stateHome;
    };
  in {
  };

  config.package = pkgs.bashInteractive;
  config.extraPackages = [
    pkgs.xdg-user-dirs
  ];
  # config.flags = {
  #   "-preset" = if config.profile == "fast" then "veryfast" else "slow";
  # };
  config.env = {
    XDG_CACHE_HOME = {
      data = "$HOME/.cache";
      esc-fn = wlib.escapeShellArgWithEnv; # runtime env-var expansion
    };
    XDG_CONFIG_HOME = {
      data = "$HOME/.config";
      esc-fn = wlib.escapeShellArgWithEnv;
    };
    XDG_DATA_HOME = {
      data = "$HOME/.local/share";
      esc-fn = wlib.escapeShellArgWithEnv;
    };
    XDG_STATE_HOME = {
      data = "$HOME/.local/state";
      esc-fn = wlib.escapeShellArgWithEnv;
    };

    # XDG User Directories

    XDG_DOWNLOAD_DIR = {
      data = "$HOME/downloads";
      esc-fn = wlib.escapeShellArgWithEnv;
    };
    XDG_PICTURES_DIR = {
      data = "$HOME/pictures";
      esc-fn = wlib.escapeShellArgWithEnv;
    };
  };

  config.runShell = [{
    name = "SETUP_CMD";
    data = ''
      [[ -L "''${XDG_CACHE_HOME}"   ]] || mkdir -p "''${XDG_CACHE_HOME}"
      [[ -L "''${XDG_CONFIG_HOME}"  ]] || mkdir -p "''${XDG_CONFIG_HOME}"
      [[ -L "''${XDG_DATA_HOME}"    ]] || mkdir -p "''${XDG_DATA_HOME}"
      [[ -L "''${XDG_STATE_HOME}"   ]] || mkdir -p "''${XDG_STATE_HOME}"
      [[ -L "''${XDG_DOWNLOAD_DIR}" ]] || mkdir -p "''${XDG_DOWNLOAD_DIR}"
      [[ -L "''${XDG_PICTURES_DIR}" ]] || mkdir -p "''${XDG_PICTURES_DIR}"

      echo 'enabled=False' > "''${XDG_CONFIG_HOME}/user-dirs.conf"

      # TODO: Create `user-dirs.dirs`
    '';
  }];
})).config.wrapper

