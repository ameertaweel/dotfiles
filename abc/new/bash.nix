{ nix-wrapper-modules }:

(nix-wrapper-modules.lib.evalModule (
  {
    config,
    wlib,
    lib,
    pkgs,
    ...
  }:
  let
    types = lib.types;
    pathAsStr = types.coercedTo types.path toString types.str;
  in
  {
    # You can only grab the final package if you supply pkgs!
    # But if you were making it for someone else, you would want them to do that!

    # include wlib.modules.makeWrapper and wlib.modules.symlinkScript
    imports = [ wlib.modules.default ];
    # The core options are focused on building a wrapper derivation.
    # different wrapper options may be implemented on top, for things like bubblewrap or other tools.
    # `wlib.modules.default` gives you a great module-based pkgs.makeWrapper to use.

    options = {
      configDrvOutput = lib.mkOption {
        type = types.str;
        default = config.outputName;
        description = ''
          The derivation output name the generated configuration will be output to.
        '';
      };
      bashrc = lib.mkOption {
        type = types.lines;
        default = "";
        example = ''
          export HISTCONTROL='ignoredups:erasedups'
          set -o vi
        '';
        description = ".bashrc config";
      };
    };

    config.package = lib.mkDefault pkgs.bashInteractive;

    config.flags = {
      "--rcfile" = lib.mkIf (config.bashrc != "") config.constructFiles.bashrc.path;
    };

    config.constructFiles = {
      bashrc = lib.mkIf (config.bashrc != "") {
        content = config.bashrc;
        relPath = "${config.binName}rc";
        output = config.configDrvOutput;
        builder = ''
          ${lib.getExe pkgs.shellcheck-minimal} --shell bash --severity=style "$1"
          cp "$1" "$2"
        '';
      };
    };
  }
))
