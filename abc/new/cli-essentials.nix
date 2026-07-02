{config, lib, pkgs, ...}: {
  environment.systemPackages = let
    wrappedPkgs = import ./wrapped-pkgs.nix {
      inherit pkgs;
      inherit (config.custom.inputs) nix-wrapper-modules;
    };
  in [
    pkgs.file
    pkgs.tree
    pkgs.ripgrep # modern `grep`
    pkgs.fd      # modern `find`
    pkgs.bat     # modern `cat` with syntax highlighting and `git` integration
    pkgs.sd      # modern `sed`

    # Network
    pkgs.curl
    pkgs.wget

    # Compression and Decompression
    pkgs.zip
    pkgs.unzip
    pkgs.rar

    pkgs.jq

    pkgs.entr  # Run arbitrary commands when files change
    pkgs.watch # Execute a command repeatedly, and monitor the output in full-screen mode

    wrappedPkgs.btop
    wrappedPkgs.tealdeer
    wrappedPkgs.tmux

    # TODO: Better place for those guys
    wrappedPkgs.vim
    pkgs.git
  ];

  programs.htop.enable = true;

  # TODO: Move Vim plugins into a Vim module
  nixpkgs.config.allowUnfreePackages = [ "rar" "vim-windowswap" "vim-polyglot" ];
}
