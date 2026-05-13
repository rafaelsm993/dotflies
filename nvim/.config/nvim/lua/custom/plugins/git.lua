return {
  -- LazyGit: full-featured git TUI (requires `lazygit` binary)
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>',                desc = '[G]it: open LazyGit' },
      { '<leader>gf', '<cmd>LazyGitCurrentFile<cr>',     desc = '[G]it: LazyGit current file' },
      { '<leader>gl', '<cmd>LazyGitFilter<cr>',          desc = '[G]it: LazyGit log (repo)' },
      { '<leader>gL', '<cmd>LazyGitFilterCurrentFile<cr>', desc = '[G]it: LazyGit log (current file)' },
    },
  },

  -- Diffview: VSCode-style side-by-side diff + file history panel
  {
    'sindrets/diffview.nvim',
    lazy = true,
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>',              desc = '[G]it: diff working tree' },
      { '<leader>gD', '<cmd>DiffviewOpen HEAD~1<cr>',       desc = '[G]it: diff vs last commit' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>',     desc = '[G]it: file history' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>',       desc = '[G]it: repo history' },
      { '<leader>gx', '<cmd>DiffviewClose<cr>',             desc = '[G]it: close diff view' },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = 'diff2_horizontal' },
        file_history = { layout = 'diff2_horizontal' },
      },
    },
  },
}
