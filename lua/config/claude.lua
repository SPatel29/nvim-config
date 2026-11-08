-- <leader>a: show/hide a Claude Code session in a split on the right.
-- Hiding keeps the session running, so the conversation is still there when you reopen it.
-- Inside the Claude split: <C-h> jumps back to your code (still in insert mode when you return).

local state = { buf = nil, job = nil }

local function claude_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == state.buf then return win end
  end
end

local function running()
  return state.buf and vim.api.nvim_buf_is_valid(state.buf) and state.job and vim.fn.jobwait({ state.job }, 0)[1] == -1
end

local function toggle()
  local win = claude_win()
  if win then
    vim.api.nvim_win_hide(win)
    return
  end

  vim.cmd("botright vsplit")
  vim.api.nvim_win_set_width(0, math.floor(vim.o.columns * 0.4))

  if running() then
    vim.api.nvim_win_set_buf(0, state.buf)
  else
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then vim.api.nvim_buf_delete(state.buf, { force = true }) end
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, state.buf)
    state.job = vim.fn.jobstart({ "claude" }, { term = true, cwd = vim.fn.getcwd() })
    vim.bo[state.buf].bufhidden = "hide"
    vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { buffer = state.buf, desc = "Go to left window" })
  end

  vim.wo.number, vim.wo.relativenumber, vim.wo.signcolumn = false, false, "no"
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>a", toggle, { desc = "Toggle Claude Code" })

-- Typing goes straight into Claude whenever you move back into its window
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("ClaudeTerm", { clear = true }),
  callback = function(ev)
    if ev.buf == state.buf then vim.cmd("startinsert") end
  end,
})
