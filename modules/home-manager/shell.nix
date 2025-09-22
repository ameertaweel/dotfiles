{
  config,
  pkgs,
  ...
}: let
  shellAliases = {
    # Fast `cd` to parent directory
    ".." = "cd ..";
    ".1" = "cd ..";
    ".2" = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".5" = "cd ../../../../..";

    # Create parent directories on demand
    mkdir = "mkdir -pv";
  };
in {
  imports = [
    ./rar.nix
    ./top.nix
  ];

  home.sessionVariables = {
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
  };

  home.shellAliases = {
    # Enable `grep` colors when the output is a terminal
    grep = "grep --color=auto";
    egrep = "egrep --color=auto";
    fgrep = "fgrep --color=auto";

    # Tolerate Mistakes
    sl = "ls";
    "cd.." = "cd ..";

    # Alias `wget` to use a custom hsts cache file location:
    wget = "wget --hsts-file='${config.xdg.dataHome}/wget-hsts'";
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      # Enable Vi bindings
      set -o vi
    '';
    historyFile = "${config.xdg.stateHome}/bash/history";
    historyIgnore = ["ls" "cd" "exit"];
    inherit shellAliases;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${builtins.readFile ./fish_config.fish}
      ${pkgs.nix-your-shell}/bin/nix-your-shell fish | source
    '';
    inherit shellAliases;
  };

  # Easy directory jumping in all shells
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.eza.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    cht-sh # Access cheatsheets from terminal

    file # Determina file type
    tree # List directory contents in a tree-like format
    curl # Transfer URLs

    ffmpeg # Video Converter

    ripgrep # `grep` clone
    fd # `find` clone
    bat # `cat` clone with syntax highlighting and `git` integration
    sd # `sed` replacement

    zip # Zip Compression
    unzip # Zip Decompression

    entr # Run arbitrary commands when files change
    watch # Execute a command repeatedly, and monitor the output in full-screen mode

    # clipboard-jh # Terminal clipboard

    eva # Calculator

    sshfs

    mosh

    carapace
  ];

  # `tldr` comand
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };
}
