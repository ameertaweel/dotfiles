-- TMUX Files
vim.filetype.add({
   extension = {
      tmux = 'tmux'
   }
})

-- Filetype For Large Files
vim.filetype.add({
   pattern = {
      ['.*'] = {
         function(path, buf)
            if not path or not buf or vim.bo[buf].filetype == 'bigfile' then
               return
            end
            if path ~= vim.api.nvim_buf_get_name(buf) then
               return
            end
            local size = vim.fn.getfsize(path)
            if size == -2 then
               return 'bigfile'
            end
            if size == -1 then
               return
            end
            local lines = vim.api.nvim_buf_line_count(buf)
            if require('utils').is_large_file(size, lines) then
               return 'bigfile'
            end
         end
      }
   }
})
