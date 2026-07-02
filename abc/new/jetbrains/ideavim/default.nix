{ ... }: {
  file.xdg_config."ideavim/ideavimrc".text = ''
    source ${./settings.vim}
    source ${./keybindings.vim}
    source ${./plugins.vim}
  '';
}
