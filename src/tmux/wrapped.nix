{ nix-wrapper-modules, ... }:

nix-wrapper-modules.wrappers.tmux.apply (
  { ... }: {
    configAfter = ''
      # Keybindings
      source-file ${./config/keybindings.tmux}

      # Styles
      source-file ${./config/styles.tmux}

      # Settings
      source-file ${./config/settings.tmux}
    '';
  }
)
