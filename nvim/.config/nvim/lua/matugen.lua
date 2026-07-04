 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#162127',
    base01 = '#243842',
    base02 = '#21323b',
    base03 = '#5e6c72',
    base04 = '#afb4b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#8966cc',
    base0A = '#5c6fd6',
    base0B = '#67bae4',
    base0C = '#b296e9',
    base0D = '#93ceec',
    base0E = '#96a3e9',
    base0F = '#910017',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#162127' })
  hi('TelescopeBorder',         { fg = '#5e6c72',             bg = '#162127' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#162127' })
  hi('TelescopePromptBorder',   { fg = '#5e6c72',             bg = '#162127' })
  hi('TelescopePromptPrefix',   { fg = '#67bae4',             bg = '#162127' })
  hi('TelescopePromptCounter',  { fg = '#afb4b6',  bg = '#162127' })
  hi('TelescopePromptTitle',    { fg = '#162127',             bg = '#67bae4' })
  hi('TelescopePreviewTitle',   { fg = '#162127',             bg = '#5c6fd6' })
  hi('TelescopeResultsTitle',   { fg = '#162127',             bg = '#8966cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#21323b' })
  hi('TelescopeSelectionCaret', { fg = '#67bae4',             bg = '#21323b' })
  hi('TelescopeMatching',       { fg = '#67bae4',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
