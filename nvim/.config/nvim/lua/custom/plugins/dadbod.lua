-- SQL database explorer: vim-dadbod (engine) + vim-dadbod-ui (sidebar/query UI)
-- SQLite connection string: sqlite:path/to/file.db3  (relative or absolute)
-- Open UI with <leader>db, or :DBUI

---@module 'lazy'
---@type LazySpec
return {
  {
    'tpope/vim-dadbod',
    lazy = true,
  },

  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      'tpope/vim-dadbod',
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    keys = {
      { '<leader>db', '<cmd>DBUIToggle<cr>', desc = '[D]ata[b]ase: toggle UI' },
    },
    ---@module 'vim-dadbod-ui'
    opts = {
      db_ui_use_nerd_fonts = true,
      db_ui_save_location = vim.fn.stdpath 'data' .. '/dadbod_ui',
    },
    config = function(_, opts)
      for k, v in pairs(opts) do
        vim.g[k] = v
      end
    end,
  },
}
