---@module 'lazy'
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'BufReadPost',
  -- uses config (not opts) to apply custom highlights after setup
  config = function()
    require('treesitter-context').setup {
      max_lines = 3,
      min_window_height = 20,
    }

    local function apply_hl()
      local sep_color = vim.api.nvim_get_hl(0, { name = 'LineNr', link = false }).fg
      vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true, sp = sep_color })
    end

    apply_hl()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('treesitter-context-hl', { clear = true }),
      callback = apply_hl,
    })
  end,
  keys = {
    {
      '[c',
      function() require('treesitter-context').go_to_context(vim.v.count1) end,
      desc = 'Jump to context (upwards)',
      silent = true,
    },
  },
}
