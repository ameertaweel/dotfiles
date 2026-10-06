{ nix-wrapper-modules, ... }:

let
  wrapper = import ./wrapper.nix { inherit nix-wrapper-modules; };
in
wrapper.apply (
  { ... }: {
    plugins.ideavim = {
      enable = true;
      ideavimrc.content = ''
        source ${./ideavim/settings.vim}
        source ${./ideavim/keybindings.vim}
        source ${./ideavim/plugins.vim}
      '';
    };
  }
)
