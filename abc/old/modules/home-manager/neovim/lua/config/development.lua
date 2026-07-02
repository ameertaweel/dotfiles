-- +------------------+
-- | Development Tips |
-- +------------------+
--
-- Evaluate Entire File:
-- :source %
--
-- Evaluate Visual Selection:
-- :'<,'>lua
--
-- Evaluate Line Under Cursor:
-- :.lua
--
-- Evaluate Lua Code:
-- :lua LUA_CODE
--

vim.api.nvim_create_user_command(
   'ExecuteLuaFile', ':source %',
   { desc = 'execute lua file' }
)

vim.api.nvim_create_user_command('ExecuteLuaSnippet', function(opts)
   vim.api.nvim_cmd({
      cmd  = 'lua',
      range = { opts.line1, opts.line2 },
   }, {})
end, { range = true, desc = 'execute lua snippet (works in normal mode and visual mode)' })
