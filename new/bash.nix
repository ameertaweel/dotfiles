{nix-wrapper-modules, pkgs}:

(nix-wrapper-modules.lib.evalModule ({ config, wlib, lib, ... }: {
  # You can only grab the final package if you supply pkgs!
  # But if you were making it for someone else, you would want them to do that!

  config.pkgs = pkgs;

  # include wlib.modules.makeWrapper and wlib.modules.symlinkScript
  imports = [ wlib.modules.default ];
  # The core options are focused on building a wrapper derivation.
  # different wrapper options may be implemented on top, for things like bubblewrap or other tools.
  # `wlib.modules.default` gives you a great module-based pkgs.makeWrapper to use.

  config.package = pkgs.bashInteractive;
  config.extraPackages = [
    pkgs.xdg-user-dirs
  ];
  # config.flags = {
  #   "-preset" = if config.profile == "fast" then "veryfast" else "slow";
  # };
  config.env = {
    EDITOR = "vim";

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
      mkdir -p $XDG_CACHE_HOME
      mkdir -p $XDG_CONFIG_HOME
      mkdir -p $XDG_DATA_HOME
      mkdir -p $XDG_STATE_HOME
      mkdir -p $XDG_DOWNLOAD_DIR
      mkdir -p $XDG_PICTURES_DIR
    '';
  }];
})).config.wrapper

