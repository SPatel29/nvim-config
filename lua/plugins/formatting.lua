-- Format with <leader>cf (not on save, since files auto save)
-- JS/TS: ESLint fixes, then project's prettier from node_modules, or prettierd | Python: ruff
-- No formatter for the file type? Falls back to the language server's formatting.
local prettier = { "prettierd", "prettier", stop_after_first = true }

local function format()
  if vim.fn.exists(":LspEslintFixAll") == 2 then
    vim.cmd("LspEslintFixAll")
  end
  require("conform").format({ async = true, lsp_format = "fallback" })
end

return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", format, mode = "", desc = "Format file" },
  },
  opts = {
    formatters_by_ft = {
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,
      css = prettier,
      html = prettier,
      python = { "ruff_organize_imports", "ruff_format" },
    },
  },
}
