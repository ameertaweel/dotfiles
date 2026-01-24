{nix-wrapper-modules, pkgs}:

nix-wrapper-modules.wrappers.tmux.wrap ({ ... }: {
  inherit pkgs;

  configAfter = ''
    # Keybindings
    source-file ${./keybindings.tmux}

    # Styles
    source-file ${./styles.tmux}

    # Settings
    source-file ${./settings.tmux}
  '';
})
