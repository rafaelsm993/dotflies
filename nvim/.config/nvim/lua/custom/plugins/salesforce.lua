-- Salesforce development support:
-- • Apex (.cls, .trigger) → filetype detection + apex_ls LSP (via Mason) + treesitter
-- • LWC / Aura (JS, HTML, CSS, XML) → prettier formatting via conform.nvim

---@module 'lazy'
---@type LazySpec
return {
  -- Filetype detection for Salesforce file extensions
  {
    'nvim-treesitter/nvim-treesitter',
    optional = true,
    init = function()
      vim.filetype.add {
        extension = {
          cls = 'apex',
          trigger = 'apex',
          apex = 'apex',
        },
      }
    end,
  },

  -- Apex LSP: Mason installs the JAR as 'apex-language-server' (requires Java)
  -- apex_ls is NOT in the main servers table to avoid Mason name mismatch.
  -- Uses init (not config) to avoid replacing kickstart's lspconfig config function.
  {
    'neovim/nvim-lspconfig',
    optional = true,
    dependencies = {
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        optional = true,
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { 'apex-language-server' })
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyDone',
        once = true,
        callback = function()
          vim.lsp.config('apex_ls', {
            apex_jar_path = vim.fn.stdpath 'data' .. '/mason/share/apex-language-server/apex-jorje-lsp.jar',
          })
          vim.lsp.enable 'apex_ls'
        end,
      })
    end,
  },

  -- Prettier formatting for LWC (JS/HTML/CSS) and Aura (XML) components
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.javascript = opts.formatters_by_ft.javascript or { 'prettier', stop_after_first = true }
      opts.formatters_by_ft.html = opts.formatters_by_ft.html or { 'prettier', stop_after_first = true }
      opts.formatters_by_ft.css = opts.formatters_by_ft.css or { 'prettier', stop_after_first = true }
      opts.formatters_by_ft.xml = opts.formatters_by_ft.xml or { 'prettier', stop_after_first = true }
      return opts
    end,
  },
}
