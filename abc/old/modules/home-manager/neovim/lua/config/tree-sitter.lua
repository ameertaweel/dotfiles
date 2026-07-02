---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
   sync_install     = false,
   auto_install     = false,
   ensure_installed = { },
   ignore_install   = { },

   highlight = {
      enable = true,

      disable = function (lang, buf)
         local max_filesize = 100 * 1024 -- 100 KB
         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
         if ok and stats and stats.size > max_filesize then
            return true
         end
      end,

      additional_vim_regex_highlighting = { },
   },

   indent = {
      enable = true,
   },
}

-- Folding
vim.api.nvim_create_augroup('SMART_FOLD_METHOD', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
   group = 'SMART_FOLD_METHOD',
   pattern = { '*' },
   callback = function (_)
      if require('nvim-treesitter.parsers').has_parser() then
         -- If a TreeSitter parser is available
         -- Use TreeSitter folding
         vim.opt_local.foldmethod = 'expr'
         vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      else
         -- Use default folding
         vim.opt_local.foldmethod = 'syntax'
      end
   end
})

-- Indent Blankline
require('ibl').setup {
   scope = {
      enabled = true,
   },
   exclude = {
      buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt', 'help' },
   },
}

require('nvim-ts-autotag').setup { }
