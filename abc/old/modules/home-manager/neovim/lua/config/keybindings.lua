vim.g.mapleader = ' '

local wk = require('which-key')

-- Window Movement

local directions = {
   h = 'left',
   j = 'down',
   k = 'up',
   l = 'right',
}
for k, v in pairs(directions) do
   wk.add({
      string.format('<c-%s>',  k), string.format('<c-w>%s', k),
      mode    = 'n',
      desc    = string.format('go to %s window', v),
      noremap = true,
   })
end

-- Window Splits

wk.add({
   mode    = 'n',
   noremap = true,
   { '<leader>-', '<cmd>split<cr>',  desc = 'split window horizontally' },
   { '<leader>/', '<cmd>vsplit<cr>', desc = 'split window vertically'   },
})

-- Tabs

wk.add({
   mode    = 'n',
   noremap = true,
   { '<leader>T', group = 'tab' },
   { '<leader>Tn', '<cmd>tabnew<cr>',   desc = 'new tab'   },
   { '<leader>Tc', '<cmd>tabclose<cr>', desc = 'close tab' },
})

-- Toggle

wk.add({
   mode    = 'n',
   noremap = true,
   { '<leader>t', group = 'toggle' },
   { '<leader>th', '<cmd>noh<cr>',            desc = 'remove last search highlights' },
   { '<leader>tu', '<cmd>UndotreeToggle<cr>', desc = 'toggle undo tree'              },
})

-- System Clipboard

wk.add({
   mode    = 'n',
   noremap = true,
   silent = true,
   { '<leader>y', '"+y',  desc = 'yank to clipboard'                     },
   { '<leader>Y', '"+y$', desc = 'yank (untill line end) to clipboard'   },

   { '<leader>p', '"+p',  desc = 'paste from clipboard'                  },
   { '<leader>P', '"+P',  desc = 'paste from clipboard'                  },

   { '<leader>d', '"+d',  desc = 'delete to clipboard'                   },
   { '<leader>D', '"+d$', desc = 'delete (untill line end) to clipboard' },
})

wk.add({
   mode    = 'v',
   noremap = true,
   silent = true,
   { '<leader>y', '"+y',  desc = 'yank to clipboard'    },
   { '<leader>p', '"+p',  desc = 'paste from clipboard' },
   { '<leader>P', '"+P',  desc = 'paste from clipboard' },
   { '<leader>d', '"+d',  desc = 'delete to clipboard'  },
})

-- Quickfix List

wk.add({
   mode    = 'n',
   noremap = true,
   { '<leader>q', group = 'quickfix list' },
   { '<leader>qp', '<cmd>cprev<cr>',  desc = 'prev quickfix list item'  },
   { '<leader>qn', '<cmd>cnext<cr>',  desc = 'next quickfix list item'  },
   { '<leader>qo', '<cmd>copen<cr>',  desc = 'open quickfix list'       },
   { '<leader>qc', '<cmd>cclose<cr>', desc = 'close quickfix list'      },
   { '<leader>qf', '<cmd>cfirst<cr>', desc = 'first quickfix list item' },
   { '<leader>ql', '<cmd>clast<cr>',  desc = 'last quickfix list item'  },
})

-- Misc

wk.add({
   mode    = 'n',
   noremap = true,
   silent  = true,
   { '<cr>', 'o<esc>', desc = 'insert new line' },
})

wk.add({
   mode    = 'v',
   noremap = true,
   silent  = true,
   { '<leader><leader>p', '"_dP', desc = 'paste and keep content' },
   { '<leader><leader>P', '"_dP', desc = 'paste and keep content' },
})
