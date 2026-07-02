-- Hybrid Line Numbers

vim.opt.number         = true -- Show current line number
vim.opt.relativenumber = true -- Relative line numbers

-- Search

vim.opt.incsearch      = true -- Select items found in search
vim.opt.hlsearch       = true -- Highlight searches by default
vim.opt.ignorecase     = true -- Ignore case when searching
vim.opt.smartcase      = true -- Unless you type a capital

-- Indentation

vim.opt.breakindent    = true  -- Keep indentation for wrapped lines
vim.opt.autoindent     = true  -- Enable auto-indentation
vim.opt.smartindent    = true  -- Enable smart-indentation
vim.opt.expandtab      = false -- Use tabs not spaces
vim.opt.shiftwidth     = 4     -- Set tab width
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 0     -- Use hard tabs always

-- Temporary Files

vim.opt.undofile       = true  -- Enable persistent undo
vim.opt.backup         = true  -- Enable backup files
vim.opt.swapfile       = true  -- Enable swap files
vim.opt.history        = 10000 -- Number of saved commands in history

-- Other

vim.opt.textwidth      = 80    -- Set chars-per-line-limit
vim.opt.colorcolumn    = '81'  -- Show column indicating the chars-per-line limit
vim.opt.wrap           = false -- Do not wrap lines

vim.opt.cursorline     = true
vim.opt.cursorcolumn   = true

vim.opt.splitright     = true
vim.opt.splitbelow     = true

vim.opt.scrolloff      = 10    -- Number of vertical context lines
vim.opt.sidescrolloff  =  5    -- Number of horizontal context lines

vim.opt.laststatus     = 2     -- Always show status line for all windows
vim.opt.cmdheight      = 1     -- Space given for displaying messages

vim.opt.confirm        = true  -- Confirm operations that would fail normally (like closing an unsaved buffer)
vim.opt.hidden         = true  -- Allow leaving buffers without saving, leaving buffer in background
vim.opt.autoread       = true  -- Automatically re-read files if modified outside the editor
vim.opt.modeline       = false -- Ignore file’s mode lines

vim.opt.updatetime     = 100   -- Long updatetime leads to noticeable delays
vim.opt.timeoutlen     = 500   -- Time to wait for a keybinding to complete

vim.opt.termguicolors  = true  -- Enable true color
vim.opt.mouse          = 'a'   -- Enable mouse support for scrolling and resizing
vim.opt.title          = true  -- Set the window’s title, reflecting the file currently being edited
vim.opt.signcolumn     = 'yes' -- Always show sign column
vim.opt.showcmd        = true  -- Show incomplete commands at the bottom
vim.opt.wildmenu       = true  -- Enable expanding commands with the tab key

vim.opt.list = true
vim.opt.listchars = {
   eol = '↲',
   trail = '·',
   space = '.',
   tab = '-->',
}

vim.opt.viewoptions = { 'folds', 'cursor' }

-- Use a block cursor in insert mode
vim.opt.guicursor      = 'i:block'
-- Allow backspacing over indention, line breaks and insertion start
vim.opt.backspace      = { 'indent', 'eol', 'start' }
-- Auto-completion options
vim.opt.completeopt    = { 'menuone', 'noinsert', 'noselect', 'preview' }

-- Don't clutter working directory with backup files
vim.opt.backupdir:remove { '.' }
-- Use diff mode vertical split
vim.opt.diffopt:append { 'vertical' }
-- Don't pass messages to |insertion-completion-menu|
vim.opt.shortmess:append 'c'

-- Disable folding everything when opening a file
vim.opt.foldenable = false
vim.opt.foldlevel  = 99
