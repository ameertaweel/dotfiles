{lib, pkgs, ...}: {
  environment.systemPackages = [
    pkgs.file
    pkgs.tree
    pkgs.ripgrep
    pkgs.fd
    pkgs.bat
    pkgs.sd

    # Network
    pkgs.curl
    pkgs.wget

    # Compression and Decompression
    pkgs.zip
    pkgs.unzip
    pkgs.rar

    pkgs.jq

    pkgs.vim

    pkgs.entr
    pkgs.watch

    pkgs.git #????
    pkgs.tmux #????
  ];

  programs.htop.enable = true;

  custom.nixpkgs.allowUnfreePredicates = [
    (
      pkg:
      builtins.elem (lib.getName pkg) [
        "rar"
      ]
    )
  ];
}
