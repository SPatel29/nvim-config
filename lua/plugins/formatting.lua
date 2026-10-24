-- Format on save
-- JS/TS: project's prettier from node_modules, or prettierd | Python: ruff
local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true }) end, mode = "", desc = "Format file" },
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
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
  },
}
