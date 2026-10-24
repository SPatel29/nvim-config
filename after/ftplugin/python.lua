-- Runs only in Python buffers

-- Run current file in a terminal split (uses .venv if present)
vim.keymap.set("n", "<leader>rr", function()
  local python = vim.uv.fs_stat(".venv/bin/python") and ".venv/bin/python" or "python3"
  vim.cmd("write")
  vim.cmd("botright split | resize 15 | terminal " .. python .. " " .. vim.fn.shellescape(vim.fn.expand("%")))
end, { buffer = true, desc = "Run Python file" })
