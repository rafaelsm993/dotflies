-- Copilot inline completions via blink.cmp source.
-- Requires Node 24 (not 26): mise use --global node@24

---@module 'lazy'
---@type LazySpec
return {
  -- Copilot backend (handles auth + suggestions)
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    ---@module 'copilot'
    ---@type copilot_config
    opts = {
      suggestion = { enabled = false }, -- blink-copilot drives suggestions
      panel = { enabled = false },
      filetypes = {
        TelescopePrompt = false,
        help = false,
        gitcommit = false,
      },
    },
  },

  -- blink.cmp source that pulls from copilot.lua
  { 'fang2hou/blink-copilot', dependencies = { 'zbirenbaum/copilot.lua' } },

  -- Extend blink.cmp to include the copilot source
  {
    'saghen/blink.cmp',
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = vim.list_extend(opts.sources.default or {}, { 'copilot' })
      opts.sources.providers = vim.tbl_deep_extend('force', opts.sources.providers or {}, {
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          score_offset = 100,
          async = true,
        },
      })
      opts.completion = vim.tbl_deep_extend('force', opts.completion or {}, {
        ghost_text = { enabled = true },
      })
      return opts
    end,
  },
}
