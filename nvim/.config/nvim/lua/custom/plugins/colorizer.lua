---@module 'lazy'
---@type LazySpec
return {
  'NvChad/nvim-colorizer.lua',
  event = { 'BufReadPre', 'BufNewFile' },
  ---@module 'colorizer'
  ---@type colorizer.Config
  opts = {
    filetypes = { '*' },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      RRGGBBAA = true,
      names = false,
      mode = 'virtualtext',
      virtualtext = '■',
      virtualtext_inline = true, -- place it right after the hex, not at EOL
    },
  },
}
