-- Auto save: write the file when you leave insert mode, change text in normal mode
-- (dd, p, u, ...), switch buffers, or switch away from nvim. Doesn't format (use <leader>cf).
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, {
  group = vim.api.nvim_create_augroup("auto_save", { clear = true }),
  callback = function(args)
    local bo = vim.bo[args.buf]
    -- Only real files: skip the explorer, help, terminals, and unnamed buffers
    if bo.buftype ~= "" or not bo.modifiable or bo.readonly or vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end
    vim.api.nvim_buf_call(args.buf, function() vim.cmd("silent! update") end)
  end,
})
