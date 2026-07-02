-- Automatically Re-Balance Windows on Resize
vim.api.nvim_create_augroup('AUTO_REBALANCE', { clear = true })
vim.api.nvim_create_autocmd('VimResized', {
   group = 'AUTO_REBALANCE',
   pattern = { '*' },
   command = 'wincmd =',
})

-- Disable Auto-Commenting
vim.api.nvim_create_augroup('DISABLE_AUTO_COMMENT', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
   group = 'DISABLE_AUTO_COMMENT',
   pattern = { '*' },
   command = 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o',
})

--[[
  Enable relative line numbers online in current window.
  Otherwise, use absolute line numbers.

  Moreover, use absolute line numbers for current window if it's in insert mode
  or NeoVim loses focus.
]]--
vim.api.nvim_create_augroup('SMART_LINE_NUMBERS', { clear = true })
local is_focused = true
local is_insert = false
local specific_event_handler = {
   WinEnter    = function ()                    end,
   FocusGained = function () is_focused = true  end,
   FocusLost   = function () is_focused = false end,
   InsertEnter = function () is_insert  = true  end,
   InsertLeave = function () is_insert  = false end,
}
vim.api.nvim_create_autocmd({
   'WinEnter'   ,
   'FocusGained', 'FocusLost',
   'InsertEnter', 'InsertLeave',
}, {
   group = 'SMART_LINE_NUMBERS',
   pattern = { '*' },
   callback = function (ev)
      specific_event_handler[ev.event]()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      local curr_win = vim.api.nvim_tabpage_get_win(0)
      for _, win in ipairs(wins) do
         local buf = vim.api.nvim_win_get_buf(win)
         local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
         -- Skip Special Buffers
         if buftype == '' then
            local is_curr_win = win == curr_win
            local relnum_enabled = is_curr_win and is_focused and not is_insert
            vim.api.nvim_set_option_value(
               'relativenumber',
               relnum_enabled,
               { scope = 'local', win = win }
            )
         end
      end
   end
})

-- Disable whitespace character hints in netrw
vim.api.nvim_create_augroup('DISABLE_NETRW_LIST', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
   group = 'DISABLE_NETRW_LIST',
   pattern = { 'netrw' },
   command = 'setlocal nolist',
})

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_augroup('HIGHLIGHT_ON_YANK', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
   desc = 'Highlight when yanking (copying) text',
   group = 'HIGHLIGHT_ON_YANK',
   callback = function ()
      vim.highlight.on_yank()
   end
})
