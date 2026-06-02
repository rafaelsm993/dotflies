-- Custom foldtext for Apex files.
-- Skips leading annotation/javadoc lines to surface the method signature.
-- Preserves indentation, samples treesitter captures at word boundaries for
-- real syntax highlighting, and appends a dimmed "{ … }" suffix.

local M = {}

function M.foldtext()
  local buf = vim.api.nvim_get_current_buf()
  local start_1 = vim.v.foldstart
  local last_1 = vim.v.foldend

  -- Find the method signature line (skip @annotations and /** * */ javadoc)
  local sig_lnum_1 = start_1
  for lnum = start_1, last_1 do
    local l = vim.fn.getline(lnum)
    if not l:match '^%s*@' and not l:match '^%s*/%*' and not l:match '^%s*%*' then
      sig_lnum_1 = lnum
      break
    end
  end

  local sig_line = vim.fn.getline(sig_lnum_1)
  local sig = sig_line:gsub('%s*{%s*$', '') -- strip trailing " {", keep leading indent
  local row = sig_lnum_1 - 1               -- treesitter uses 0-indexed rows

  -- Build highlighted chunks by sampling treesitter captures at word token starts
  local chunks = {}
  local i = 1
  local len = #sig

  while i <= len do
    local char = sig:sub(i, i)
    if char:match '[%a_]' then
      -- Scan to end of word
      local j = i
      while j <= len and sig:sub(j, j):match '[%w_]' do
        j = j + 1
      end
      local token = sig:sub(i, j - 1)
      local ok, captures = pcall(vim.treesitter.get_captures_at_pos, buf, row, i - 1)
      local hl = 'Normal'
      if ok and #captures > 0 then
        hl = '@' .. captures[#captures].capture
      end
      table.insert(chunks, { token, hl })
      i = j
    else
      -- Non-word run: whitespace, punctuation, generics angle brackets, etc.
      local j = i
      while j <= len and not sig:sub(j, j):match '[%a_]' do
        j = j + 1
      end
      table.insert(chunks, { sig:sub(i, j - 1), 'Normal' })
      i = j
    end
  end

  table.insert(chunks, { ' { … }', 'Comment' })
  return chunks
end

return M
