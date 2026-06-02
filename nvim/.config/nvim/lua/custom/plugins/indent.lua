-- Indentation guides: dim static lines (ibl) + animated current-scope highlight (mini.indentscope)
---@module 'lazy'
---@type LazySpec
return {
  -- Static guides on every indent level (dim, unobtrusive)
  {
    'lukas-reineke/indent-blankline.nvim',
    optional = true,
    ---@module 'ibl'
    ---@type ibl.config
    opts = {
      indent = { char = '▏', highlight = 'IblIndent' },
      scope = { enabled = false }, -- scope handled by mini.indentscope
    },
  },

  -- Animated scope highlight: draws a line for the current block as you move
  {
    'echasnovski/mini.indentscope',
    version = false,
    event = 'BufReadPost',
    opts = {
      symbol = '▏',
      options = { try_as_border = true },
      draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.quadratic {
          easing = 'out',
          duration = 80,
          unit = 'total',
        },
      },
    },
    config = function(_, opts)
      -- Disable in special buffers
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('indent-scope-disable', { clear = true }),
        pattern = {
          'help',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
          'sf-output',
        },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
      require('mini.indentscope').setup(opts)
    end,
  },
}
