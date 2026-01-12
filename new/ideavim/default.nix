{...}: let
  configDir = "ideavim";
in {
  file.xdg_config."${configDir}/ideavimrc".text = ''
    source {{xdg_config_home}}/${configDir}/settings.vim
    source {{xdg_config_home}}/${configDir}/keybindings.vim
    source {{xdg_config_home}}/${configDir}/plugins.vim
  '';

  file.xdg_config."${configDir}/settings.vim".source = ./settings.vim;
  file.xdg_config."${configDir}/keybindings.vim".source = ./keybindings.vim;
  file.xdg_config."${configDir}/plugins.vim".source = ./plugins.vim;
}
