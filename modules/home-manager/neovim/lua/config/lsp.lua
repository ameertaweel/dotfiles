-- Configure Language Servers

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

vim.lsp.enable('nil_ls')
vim.lsp.enable('ccls')
vim.lsp.enable('superhtml')
vim.lsp.enable('cssls')
vim.lsp.enable('jsonls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('svelte')
vim.lsp.enable('basedpyright')
vim.lsp.enable('yamlls')

vim.lsp.enable('lua_ls')
require('lazydev').setup {
   library = {
      -- Load luvit types when the `vim.uv` word is found
      -- See the configuration section for more details
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
   },
}

-- Configure LSP Attach Behavior

vim.api.nvim_create_autocmd('LspAttach', {
   callback = function (args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
         return
      end
      local buf = args.buf

      local wk = require('which-key')

      local diagnostic_open_float = function ()
         vim.diagnostic.open_float({ border = 'rounded' })
      end

      wk.add({
         mode    = 'n',
         noremap = true,
         { '<leader>l', group = 'lsp' },
         { '<leader>la', vim.lsp.buf.code_action, desc = 'lsp code actions',       buffer = buf },
         { '<leader>lr', vim.lsp.buf.rename,      desc = 'lsp rename',             buffer = buf },
         { '<leader>ld', diagnostic_open_float,   desc = 'lsp expand diagnostics', buffer = buf },
         { '<leader>lf', vim.lsp.buf.format,      desc = 'lsp format',             buffer = buf },
      })
      wk.add({
         'K',
         function () vim.lsp.buf.hover({ border = 'rounded' }) end,
         desc = 'lsp hover',
         buffer = buf,
         mode    = 'n',
         noremap = true,
      })
   end,
})

-- Completions

require('blink.cmp').setup {
   keymap = { preset = 'default' },

   appearance = {
      nerd_font_variant = 'mono',
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
   },

   sources = {
      default = { 'lsp', 'path', 'buffer' },
   },

   cmdline = {
      enabled = true,
      completion = {
         menu = {
            auto_show = true,
         },
      },
   },

   fuzzy = {
      prebuilt_binaries = {
         download = false,
         ignore_version_mismatch = true,
      },
   },

   signature = {
      enabled = true,
   },
}
