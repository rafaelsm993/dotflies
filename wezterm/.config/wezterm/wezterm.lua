local wezterm = require 'wezterm'
local act = wezterm.action

-- ── Smart pane navigation ──────────────────────────────────────────────────
-- If the focused pane is running (n)vim, send Ctrl-W + direction so vim
-- handles its own splits. Otherwise let WezTerm switch panes.
local function is_nvim(pane)
  local proc = pane:get_foreground_process_name()
  return proc ~= nil and proc:find 'n?vim' ~= nil
end

local vim_dir = { Left = 'h', Down = 'j', Up = 'k', Right = 'l' }

local function smart_nav(direction)
  return wezterm.action_callback(function(window, pane)
    if is_nvim(pane) then
      -- 0x17 = Ctrl-W; let vim route to its own split
      window:perform_action(act.SendString('\x17' .. vim_dir[direction]), pane)
    else
      window:perform_action(act.ActivatePaneDirection(direction), pane)
    end
  end)
end

-- ── Status bar: show LEADER / key-table mode ───────────────────────────────
wezterm.on('update-status', function(window, _)
  local stat = ''
  if window:leader_is_active() then
    stat = ' LDR '
  elseif window:active_key_table() then
    stat = ' ' .. window:active_key_table():upper() .. ' '
  end
  window:set_left_status(wezterm.format {
    { Attribute = { Intensity = 'Bold' } },
    { Foreground = { Color = '#7aa2f7' } },
    { Text = stat },
  })
end)

-- ── Config ─────────────────────────────────────────────────────────────────
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'
config.font_size = 14
config.line_height = 1.2
config.cursor_blink_rate = 0
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_background_opacity = 1.0
config.color_scheme = 'Tokyo Night'
config.max_fps = 120
config.prefer_egl = true

-- DEBUG: uncomment to see key events in the debug overlay (CTRL+SHIFT+L)
-- config.debug_key_events = true

-- Disable defaults to prevent silent conflicts with the custom layout below
config.disable_default_key_bindings = true

-- ── Leader (tmux-style prefix) ────────────────────────────────────────────
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

-- ── Key tables ────────────────────────────────────────────────────────────
-- Resize mode: enter with <leader>r, use h/j/k/l, exit with q / Esc
config.key_tables = {
  resize_pane = {
    { key = 'h',      action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'l',      action = act.AdjustPaneSize { 'Right', 3 } },
    { key = 'j',      action = act.AdjustPaneSize { 'Down', 3 } },
    { key = 'k',      action = act.AdjustPaneSize { 'Up', 3 } },
    { key = 'q',      action = act.PopKeyTable },
    { key = 'Escape', action = act.PopKeyTable },
  },
}

config.keys = {
  -- ── Copy / paste (explicit, since defaults are disabled) ──────────────────
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- ── Splits ───────────────────────────────────────────────────────────────
  -- <leader>|  split right  (vertical divider)
  { key = '|', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- <leader>-  split down   (horizontal divider)
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- ── Pane navigation (vim-aware) ──────────────────────────────────────────
  { key = 'h', mods = 'LEADER', action = smart_nav 'Left' },
  { key = 'j', mods = 'LEADER', action = smart_nav 'Down' },
  { key = 'k', mods = 'LEADER', action = smart_nav 'Up' },
  { key = 'l', mods = 'LEADER', action = smart_nav 'Right' },

  -- ── Pane management ──────────────────────────────────────────────────────
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  -- <leader>r  enter resize mode (h/j/k/l to resize, q/Esc to exit)
  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },

  -- ── Tabs ─────────────────────────────────────────────────────────────────
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  -- <leader>1-9  jump directly to tab
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },
  -- <leader>,  rename tab
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Rename tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then window:active_tab():set_title(line) end
      end),
    },
  },

  -- ── Copy / search ─────────────────────────────────────────────────────────
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = '/', mods = 'LEADER', action = act.Search { CaseSensitiveString = '' } },

  -- ── Misc ──────────────────────────────────────────────────────────────────
  { key = 'f',     mods = 'LEADER',       action = act.ToggleFullScreen },
  -- Pass CTRL+Space through to the running app when needed
  { key = 'Space', mods = 'LEADER|CTRL',  action = act.SendKey { key = 'Space', mods = 'CTRL' } },
}

return config
