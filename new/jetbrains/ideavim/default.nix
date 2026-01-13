{ ... }:
let
  configDir = "ideavim";
in
{
  file.xdg_config."${configDir}/ideavimrc".text = ''
    source ${./settings.vim}
    source ${./keybindings.vim}
    source ${./plugins.vim}
  '';
}
