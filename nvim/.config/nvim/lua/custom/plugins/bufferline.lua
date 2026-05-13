return {
  {
    'akinsho/bufferline.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local ok, tn = pcall(require, 'tokyonight.colors')
      local c      = ok and tn.setup { style = 'night' } or {}

      -- tokyonight-night palette fallbacks
      local bg      = c.bg           or '#1f2335'
      local bg_dark = c.bg_dark      or '#1a1b26'
      local bg_hl   = c.bg_highlight or '#292e42'
      local fg      = c.fg           or '#c0caf5'
      local fg_dim  = c.comment      or '#565f89'
      local blue    = c.blue         or '#7aa2f7'

      require('bufferline').setup {
        options = {
          diagnostics             = 'nvim_lsp',
          show_buffer_close_icons = true,
          show_close_icon         = false,
          separator_style         = 'slant',
          always_show_bufferline  = true,
          offsets = {
            { filetype = 'NvimTree', text = 'File Explorer', highlight = 'Directory' },
          },
        },
        highlights = {
          fill                  = { bg = bg_dark },
          background            = { bg = bg,      fg = fg_dim },
          tab                   = { bg = bg,      fg = fg_dim },
          tab_selected          = { bg = bg_hl,   fg = fg,    bold = true },
          tab_close             = { bg = bg_dark,  fg = fg_dim },
          -- Slant separators: fg must equal fill.bg so the triangle appears cut-out
          separator             = { fg = bg_dark,  bg = bg },
          separator_selected    = { fg = bg_dark,  bg = bg_hl },
          separator_visible     = { fg = bg_dark,  bg = bg },
          buffer_selected       = { bg = bg_hl,   fg = fg,    bold = true },
          buffer_visible        = { bg = bg,      fg = fg_dim },
          close_button          = { bg = bg,      fg = fg_dim },
          close_button_selected = { bg = bg_hl,   fg = fg },
          indicator_selected    = { fg = blue,    bg = bg_hl },
        },
      }
    end,
    keys = {
      { '<S-l>',      '<cmd>BufferLineCycleNext<cr>',      desc = 'Next buffer tab' },
      { '<S-h>',      '<cmd>BufferLineCyclePrev<cr>',      desc = 'Prev buffer tab' },
      { '<leader>bx', '<cmd>bdelete<cr>',                  desc = '[B]uffer: close' },
      { '<leader>bX', '<cmd>BufferLineCloseOthers<cr>',    desc = '[B]uffer: close others' },
      { '<leader>bp', '<cmd>BufferLineTogglePin<cr>',      desc = '[B]uffer: pin/unpin' },
      { '<leader>b1', '<cmd>BufferLineGoToBuffer 1<cr>',   desc = '[B]uffer: go to 1' },
      { '<leader>b2', '<cmd>BufferLineGoToBuffer 2<cr>',   desc = '[B]uffer: go to 2' },
      { '<leader>b3', '<cmd>BufferLineGoToBuffer 3<cr>',   desc = '[B]uffer: go to 3' },
      { '<leader>b4', '<cmd>BufferLineGoToBuffer 4<cr>',   desc = '[B]uffer: go to 4' },
      { '<leader>b5', '<cmd>BufferLineGoToBuffer 5<cr>',   desc = '[B]uffer: go to 5' },
    },
  },
}
