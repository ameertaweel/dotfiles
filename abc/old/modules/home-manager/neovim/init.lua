-- Enable Experimental Lua Module Loader
vim.loader.enable()

require('config.development')
require('config.settings')
require('config.filetype')
require('config.autocmd')
require('config.keybindings')
require('config.lsp')
require('config.telescope')
require('config.tree-sitter')
require('config.plugins.misc')
