{
  config,
  lib,
  params,
  pkgs,
  ...
}: let
  nvim-themes = {
    ayu-dark = {
      # https://github.com/Shatur/neovim-ayu
      pkg = pkgs.vimPlugins.neovim-ayu;
      config = ''
        vim.go.background = 'dark'
        require('ayu').colorscheme()
        require('lualine').setup {
          options = { theme = 'ayu_dark' }
        }
      '';
    };
    ayu-mirage = {
      # https://github.com/Shatur/neovim-ayu
      pkg = pkgs.vimPlugins.neovim-ayu;
      config = ''
        vim.go.background = 'dark'
        require('ayu').setup({ mirage = true })
        require('ayu').colorscheme()
        require('lualine').setup {
          options = { theme = 'ayu_mirage' }
        }
      '';
    };
    ayu-light = {
      # https://github.com/Shatur/neovim-ayu
      pkg = pkgs.vimPlugins.neovim-ayu;
      config = ''
        vim.go.background = 'light'
        require('ayu').colorscheme()
        require('lualine').setup {
          options = { theme = 'ayu_light' }
        }
      '';
    };
  };
  nvim-theme = nvim-themes.${config.colorScheme.slug};
in {
  home.sessionVariables = lib.mkIf (builtins.elem params.editor ["nvim" "neovim"]) {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  programs.neovim = {
    enable = true;
    extraLuaConfig = ''
      ${builtins.readFile ./init.lua}
      ${nvim-theme.config}
    '';
    plugins = with pkgs.vimPlugins; [
      # Theme
      nvim-theme.pkg

      # Status Line
      # https://github.com/nvim-lualine/lualine.nvim
      lualine-nvim
      # Tree-Sitter Parsers
      # https://github.com/nvim-treesitter/nvim-treesitter
      (nvim-treesitter.withPlugins (p: [
        p.lua
        p.nix
        p.c
        p.cpp
        p.java
        p.rust
        p.html
        p.css
        p.scss
        p.javascript
        p.typescript
        p.json
        p.svelte
        p.vue
        p.markdown
        p.python
        p.sql
        p.just
      ]))
      # Default LSP Configurations
      # https://github.com/neovim/nvim-lspconfig
      nvim-lspconfig
      # Configures Lua Language Server for editing Neovim configs
      # https://github.com/folke/lazydev.nvim
      lazydev-nvim

      # Fuzzy Finder
      # https://github.com/nvim-telescope/telescope.nvim
      telescope-nvim
      # Telescope dependency
      # https://github.com/nvim-lua/plenary.nvim/
      plenary-nvim
      # https://github.com/nvim-telescope/telescope-fzf-native.nvim
      telescope-fzf-native-nvim

      # File Explorer
      # https://github.com/stevearc/oil.nvim
      oil-nvim
      # Icon Provider
      # https://github.com/echasnovski/mini.icons
      mini-icons

      # Auto-Complete
      # https://github.com/Saghen/blink.cmp
      blink-cmp

      # Unix shell commands in Vim
      # https://github.com/tpope/vim-eunuch
      vim-eunuch

      # Heuristically set buffer options
      # https://github.com/tpope/vim-sleuth
      vim-sleuth

      # Enable repeating supported plugin maps with "."
      # https://github.com/tpope/vim-repeat
      vim-repeat

      # Provide additional text objects
      # Cheatsheet for targets-vim in the link below:
      # https://github.com/wellle/targets.vim/blob/master/cheatsheet.md
      targets-vim

      # Highlight, List and Search TODO Comments
      # https://github.com/folke/todo-comments.nvim
      todo-comments-nvim

      # General-Purpose Motion Plugin
      # https://github.com/ggandor/leap.nvim
      leap-nvim

      # Git Integration For Buffers
      # https://github.com/lewis6991/gitsigns.nvim
      gitsigns-nvim

      # Show Available Keybindings in a Popup
      # https://github.com/folke/which-key.nvim
      which-key-nvim

      # Undo History Visualizer
      # https://github.com/mbbill/undotree
      undotree

      # Improved Neovim Quickfix List
      # https://github.com/stevearc/quicker.nvim
      quicker-nvim

      # Rename Tabs
      # https://github.com/gcmt/taboo.vim
      taboo-vim

      # Rainbow Delimiters Using TreeSitter
      # https://github.com/HiPhish/rainbow-delimiters.nvim
      rainbow-delimiters-nvim

      # Indent Guides
      # https://github.com/lukas-reineke/indent-blankline.nvim
      indent-blankline-nvim

      # Set `commentstring` Based on Cursor Location
      # https://github.com/JoosepAlviste/nvim-ts-context-commentstring
      nvim-ts-context-commentstring

      # Auto Close and Auto Rename HTML Tag
      # https://github.com/windwp/nvim-ts-autotag
      nvim-ts-autotag

      # Break Bad Habits, Master Vim Motions
      hardtime-nvim
      nui-nvim
    ];
    extraPackages = with pkgs; [
      # Wayland Clipboard Provider
      wl-clipboard

      # For Telescope
      fzf
      ripgrep

      # Language Servers
      lua-language-server
      nil
      ccls
      vscode-langservers-extracted
      superhtml
      typescript-language-server
      svelte-language-server
      basedpyright
      yaml-language-server
    ];
  };

  xdg.configFile.neovimLuaConfig = {
    target = "nvim/lua";
    source = ./lua;
    recursive = true;
  };

  xdg.configFile.neovimAfterConfig = {
    target = "nvim/after";
    source = ./after;
    recursive = true;
  };
}
