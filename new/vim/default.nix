{nix-wrapper-modules, ...}:

nix-wrapper-modules.wrappers.vim.apply ({ pkgs, ... }: {
  vimrc = ''
    " Use Vim settings rather than Vi settings
    set nocompatible

    source ${./xdg_cache.vim}
    source ${./settings.vim}
    source ${./keybindings.vim}

    " Plugins
    source ${./plugins/lightline.vim} " Statusbar
    source ${./plugins/window-swap.vim} " Swap split windows with ease
  '';

  plugins = [
   # Statusbar
   pkgs.vimPlugins.lightline-vim

   # Swap split windows with ease
   pkgs.vimPlugins.vim-windowswap

   # Git for Vim
   pkgs.vimPlugins.vim-fugitive

   # Unix shell commands in Vim
   pkgs.vimPlugins.vim-eunuch

   # Syntax and indentation support for many languages
   pkgs.vimPlugins.vim-polyglot

   # Comments for Vim
   pkgs.vimPlugins.vim-commentary

   # More text objects to operate on
   # NOTE: Cheatsheet for this plugin in the link below
   # https://github.com/wellle/targets.vim/blob/master/cheatsheet.md
   pkgs.vimPlugins.targets-vim

   # Qouting and parenthesizing made simple
   pkgs.vimPlugins.vim-surround

   # Enable repeating supported plugin maps with the "." operator
   pkgs.vimPlugins.vim-repeat

   # Heuristically set buffer options
   pkgs.vimPlugins.vim-sleuth
  ];
})
