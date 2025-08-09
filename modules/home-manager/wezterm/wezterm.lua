-- +----------+
-- | Snippets |
-- +----------+

-- Logging:
-- wezterm.log_info(MESSAGE)

-- +---------+
-- | Imports |
-- +---------+

local wezterm = require 'wezterm'

-- +-------+
-- | Utils |
-- +-------+

local function array_find(array, predicate)
    for i, v in ipairs(array) do
        if predicate(v, i) then
            -- Return the first matching value
            return v
        end
    end
    -- Return `nil` if no match is found
    return nil
end

-- +----------------------+
-- | Create Config Object |
-- +----------------------+

-- Create a config object which we will be adding our config to
local config = wezterm.config_builder()

-- +------------+
-- | Appearance |
-- +------------+

-- Removes the title bar, leaving only the tab bar.
config.window_decorations = 'NONE'

config.window_frame = {
  font = wezterm.font({ family = 'Hack Nerd Font', weight = 'Bold' }),
  font_size = 12,
}

config.color_scheme = 'Ayu Dark (Gogh)'

config.font = wezterm.font({ family = 'Hack Nerd Font' })
config.font_size = 12

-- +--------------+
-- | Key Bindings |
-- +--------------+

config.disable_default_key_bindings = true

local leader = { key = 'a', mods = 'CTRL' }

config.leader = { key = leader.key, mods = leader.mods, timeout_milliseconds = 1000 }

local function kb_move_pane(key, direction)
  return {
    key = key,
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection(direction),
  }
end

config.keys = {
  --
  -- Clipboard
  --
  { key = 'C', mods = 'CTRL', action = wezterm.action.CopyTo    'Clipboard' },
  { key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },

  --
  -- Pane
  --
  kb_move_pane('j', 'Down'),
  kb_move_pane('k', 'Up'),
  kb_move_pane('h', 'Left'),
  kb_move_pane('l', 'Right'),
  {
    key = 'z',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = '/',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'r',
    mods = 'LEADER',
    action = wezterm.action.ActivateKeyTable {
      name = 'resize_panes',
      -- Don't deactivate keytable after it handles its first keypress
      one_shot = false,
      -- Deactivate the keytable after a timeout
      timeout_milliseconds = 1000,
    },
  },
  {
    -- Go To Pane
    key = 'g',
    mods = 'LEADER',
    action = wezterm.action.PaneSelect,
  },
  {
    -- Swap Pane
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.PaneSelect { mode = 'SwapWithActive' },
  },

  --
  -- Tab
  --
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  { key = 'p', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = wezterm.action.ActivateTabRelative( 1) },
  { key = 'P', mods = 'LEADER', action = wezterm.action.MoveTabRelative(-1) },
  { key = 'N', mods = 'LEADER', action = wezterm.action.MoveTabRelative( 1) },
  {
    key = 'X',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = ',',
    mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = 'Enter New Name For Tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- `line` will be `nil` if user presses escape without entering anything
        -- If the user just presses enter, `line` will be an empty string
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  --
  -- Misc
  --
  {
    key = 'e',
    mods = 'LEADER',
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = 'd',
    mods = 'LEADER',
    action = wezterm.action.ShowDebugOverlay,
  },
  {
    -- Pressing the leader key twice sends the leader key to the terminal
    key = leader.key,
    mods = 'LEADER' .. '|' .. leader.mods,
    action = wezterm.action.SendKey { key = leader.key, mods = leader.mods },
  },
  {
    -- CTRL+BACKSPACE deletes a word
    key = 'Backspace',
    mods = 'CTRL',
    action = wezterm.action.SendKey { key = 'w', mods = 'CTRL' },
  },
  {
    key = 'mapped:_',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = 'mapped:+',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = 'F11',
    mods = '',
    action = wezterm.action.ToggleFullScreen,
  },
  -- Clear the scrollback and viewport leaving the prompt line the new first line
  {
    key = 'l',
    mods = 'LEADER|CTRL',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
}

local function kb_activate_tab(key, tab)
  return {
    key = tostring(key),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(tab),
  }
end

-- Activate Tab By Number
for i = 1, 9 do
  table.insert(config.keys, kb_activate_tab(i, i - 1))
end
table.insert(config.keys, kb_activate_tab(0, 9))

-- +------------+
-- | Key Tables |
-- +------------+

local function kb_resize_pane(key, direction)
  return {
    key = key,
    action = wezterm.action.AdjustPaneSize { direction, 3 }
  }
end

config.key_tables = {
  resize_panes = {
    kb_resize_pane('j', 'Down'),
    kb_resize_pane('k', 'Up'),
    kb_resize_pane('h', 'Left'),
    kb_resize_pane('l', 'Right'),
  },
}

-- +----------------+
-- | Mouse Bindings |
-- +----------------+

config.mouse_bindings = {
  -- Change the default selection behavior so that it only selects text,
  -- but doesn't copy it to a clipboard or open hyperlinks.
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action { ExtendSelectionToMouseCursor = 'Cell' },
  },
  -- Don't automatically copy the selection to the clipboard
  -- when double clicking a word
  {
    event = { Up = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = 'Nop',
  },
  -- CTRL+Click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = 'OpenLinkAtMouseCursor',
  },
}

-- +------------+
-- | Status Bar |
-- +------------+

wezterm.on('update-status', function(window, pane)
  local color_scheme = window:effective_config().resolved_palette
  local colors = {
    black = color_scheme.ansi[1],
    red = color_scheme.ansi[2],
    green = color_scheme.ansi[3],
    yellow = color_scheme.ansi[4],
    blue = color_scheme.ansi[5],
    magenta = color_scheme.ansi[6],
    cyan = color_scheme.ansi[7],
    white = color_scheme.ansi[8],
  }

  local tab = pane:tab()

  local panes_info = {}
  if tab ~= nil then
    panes_info = tab:panes_with_info()
  end

  local status_elements = {
    { Background = { Color = colors.yellow } },
    { Foreground = { Color = colors.black } },
  }

  local active_pane_info = array_find(panes_info, function(pane_info)
    return pane_info.pane:pane_id() == pane:pane_id()
  end)

  if active_pane_info ~= nil and active_pane_info.is_zoomed then
    table.insert(status_elements, { Text = " ZOOMED " })
  end

  window:set_right_status(wezterm.format(status_elements))
end)

-- +------+
-- | Misc |
-- +------+

-- Workaround for this issue:
-- https://github.com/wezterm/wezterm/issues/3726
config.enable_wayland = false

config.launch_menu = {}

-- +------------------+
-- | Windows-Specific |
-- +------------------+

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- 'NONE' causes problems with resizing on Windows
  config.window_decorations = 'RESIZE'

  table.insert(config.launch_menu, {
    label = 'PowerShell',
    args = { 'pwsh.exe' },
  })
  table.insert(config.launch_menu, {
    label = 'Git Bash',
    args = { 'pwsh.exe', '-c', '&(Join-Path (Split-Path (Split-Path (Get-Command git).Source)) "bin/bash.exe")', '-l' },
  })
  -- table.insert(config.launch_menu, {
  --   label = 'PowerShell (Legacy)',
  --   args = { 'powershell.exe' },
  -- })
end

-- +-------------------------------+
-- | Return Config To Be Evaluated |
-- +-------------------------------+

return config
