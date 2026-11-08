-- Runs only in Python buffers

-- 4-space indents (PEP 8); the global default of 2 makes nested blocks hard to tell apart
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4

-- Run current file in a terminal split (uses .venv if present)
vim.keymap.set("n", "<leader>rr", function()
  local python = vim.uv.fs_stat(".venv/bin/python") and ".venv/bin/python" or "python3"
  vim.cmd("write")
  vim.cmd("botright split | resize 15 | terminal " .. python .. " " .. vim.fn.shellescape(vim.fn.expand("%")))
end, { buffer = true, desc = "Run Python file" })
