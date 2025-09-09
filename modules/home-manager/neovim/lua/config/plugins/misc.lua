local wk = require('which-key')

-- Status Line

require('lualine').setup {
   options = {
      globalstatus = true,
   },
}

-- TODO Comments

require('todo-comments').setup {
   signs = false,
   highlight = {
      keyword = 'bg',
   },
}

wk.add({
   mode    = 'n',
   noremap = true,
   { '<leader>ft', '<cmd>TodoTelescope<cr>', desc = 'find todo' },
})

-- Improved Quickfix List

require('quicker').setup { }

-- Git Integration

require('gitsigns').setup { }
vim.api.nvim_create_user_command(
   'GitBlameLine', 'Gitsigns blame_line',
   { desc = 'show `git blame` info for line under cursor' }
)
vim.api.nvim_create_user_command(
   'GitBlameFile', 'Gitsigns blame',
   { desc = 'show `git blame` info for current file' }
)

-- Fast Motion

require('leap').create_default_mappings()

-- Key Bindings

require('which-key').setup {
   delay = 1000,
   win = {
      border = 'rounded'
   }
}

-- Icons

require('mini.icons').setup { }

-- Rename Tabs

vim.g.taboo_tab_format = ' [%N] %f%m '
vim.g.taboo_renamed_tab_format = ' [%N] %l%m '

wk.add({
   mode    = 'n',
   noremap = true,
   { '<leader>Ts', ':exec ":TabooRename ".input("Rename Tab: ")<cr>', desc = 'set tab name'   },
   { '<leader>Tr', '<cmd>TabooReset<cr>',                             desc = 'reset tab name' },
})

-- Improved File Explorer

require('oil').setup { }

wk.add({
   '-', '<cmd>Oil<cr>',
   mode    = 'n',
   noremap = true,
   desc = 'open parent directory in file explorer'
})

-- Break Bad Habits, Master Vim Motions

require('hardtime').setup()
