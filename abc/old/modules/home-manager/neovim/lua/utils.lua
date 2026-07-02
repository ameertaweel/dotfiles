local M = {}

-- Maximum File Size (Bytes)
local max_size = 0.5 * 1024 * 1024
-- Maximum Average Bytes Per Line
local max_avg_line_bytes = 150

function M.is_large_file(size, lines)
   if size > max_size then
      return true
   end
   if size / lines > max_avg_line_bytes then
      return true
   end
   return false
end

function M.get_line_count(filepath)
   local handle = io.popen('wc -l < ' .. filepath)
   if handle == nil then
      return 0
   end
   local result = handle:read('*a')
   handle:close()
   return tonumber(result) or 0
end

return M
