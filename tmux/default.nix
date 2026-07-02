{ nix-wrapper-modules, ... }:

nix-wrapper-modules.wrappers.tmux.apply (
  { ... }: {
    configAfter = ''
      # Keybindings
      source-file ${./keybindings.tmux}

      # Styles
      source-file ${./styles.tmux}

      # Settings
      source-file ${./settings.tmux}
    '';
  }
)
